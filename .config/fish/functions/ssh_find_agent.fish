function ssh_find_agent
	set -l verb $argv[1]
	set -l agent_paths

	if set -q SSH_FIND_AGENT_PATH; set agent_paths (string split ':' -- $SSH_FIND_AGENT_PATH); end
	if set -q TMPDIR; set -a agent_paths "$TMPDIR"; end
	set -a agent_paths "$HOME/.ssh/agent"
	set -a agent_paths "$XDG_RUNTIME_DIR"
	set -l agent_sockets (
		find $agent_paths -maxdepth 2 -type s -name 'agent.*' \
			-o -name S.gpg-agent.ssh \
			-o -name ssh \
			-o -name 's.*.agent.*' \
			-o -regex '.*/ssh-.*/agent..*$' \
			2>/dev/null | \
			grep -E '/ssh-.*/agent.*|/gpg-.*/S.gpg-agent.ssh|/keyring-.*/ssh$|.*/ssh-.*/agent..*$|s\..*\.agent\..*'
	)

	function test_agent_sockets
		set -l filtered
		set -l sockets $argv

		for socket in $sockets
			set -l output
			set -l result
		
			set output (LANG=C SSH_AUTH_SOCK=$socket timeout 1s ssh-add -l 2>&1)
			set result $status
		
			if test "$output" = "error fetching identities: communication with agent failed"
				set result 2
			end
		
			switch $result
				case 0 1 141
					set -l keys (SSH_AUTH_SOCK=$socket ssh-add -l 2>/dev/null)
					set -a filtered (count $keys)":$socket"
				case 2 124
					echo "Dead socket $socket - filtering out" >&2
				case 125 126 127
					echo "timeout returned for $socket <$result>" >&2
				case '*'
					echo "Unknown failure timeout returned for $socket <$result>" >&2
			end
		end

		echo $filtered
	end
	set agent_sockets (test_agent_sockets $agent_sockets)
	set agent_sockets (printf '%s\n' $agent_sockets | sort -t: -rn)

	if test (count $agent_sockets) -eq 0
		echo "No SSH agents found. Starting a new ssh-agent..." >&2
		set -l agent_output (ssh-agent -c 2>/dev/null)
		set -l socket
		for line in $agent_output
			if string match -q 'setenv SSH_AUTH_SOCK *' $line
				set socket (string replace -r '.*SSH_AUTH_SOCK ([^;]+).*' '$1' $line)
			end
		end
		
		echo "Started new ssh-agent with socket: $socket" >&2
		set agent_sockets "0:$socket"
	end

	function fzf_socket
		printf '%s\n' $argv | fzf -d: --with-nth=2 --accept-nth=2 --preview='SSH_AUTH_SOCK={2} ssh-add -l 2>/dev/null'
	end

	function set_ssh_socket
		set -gx SSH_AUTH_SOCK $argv[1]
		set --erase SSH_AGENT_PID; or true
	end

	switch $verb
		case c choose
			set_ssh_socket (fzf_socket $agent_sockets)
		case a auto
			set_ssh_socket (string split -f2 : $agent_sockets[1])
		case l list ""
			fzf_socket $agent_sockets >/dev/null
		case h help
			echo "ssh_find_agent <c|choose|a|auto|l|list|h|help>"
			return 1
		case "*"
			echo "Unknown command: $verb"
			return 1
	end
end
