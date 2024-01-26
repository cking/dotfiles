function rmkh -d "removes a given host from ~/.ssh/known_hosts"
	set host $argv[1]

	if string match -qr '^\d+$' $host
		set host (head -n $host "$HOME/.ssh/known_hosts" | tail -n1 | cut -d" " -f1)
		set host (string split "," "$host")
		set host $host[1]
	end

	ssh-keygen -R "$host" -f "$HOME/.ssh/known_hosts"
end
