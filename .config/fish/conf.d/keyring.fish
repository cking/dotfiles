if not status is-interactive
	return
end

if type -q gnome-keyring-daemon
	replay 'eval $(gnome-keyring-daemon -s 2>/dev/null) && export SSH_AUTH_SOCK'
end

gpgconf --launch gpg-agent

keychain --dir $XDG_RUNTIME_DIR --absolute --ignore-missing --agents ssh,gpg --inherit any --quiet
replay "source $XDG_RUNTIME_DIR/.keychain/*-sh-gpg && export GPG_AGENT_INFO"

if not set -q SSH_AUTH_SOCK
	replay "source $XDG_RUNTIME_DIR/.keychain/*-sh && export SSH_AUTH_SOCK"
end
