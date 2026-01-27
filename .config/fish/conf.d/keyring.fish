if not status is-interactive
	return
end

set -x SSH_ASKPASS /usr/lib/seahorse/ssh-askpass
set -x SSH_ASKPASS_REQUIRE prefer

if set -q SSH_AUTH_SOCK and set -q GNOME_KEYRING_CONTROL
	return
end

if type -q gnome-keyring-daemon and not set -q GNOME_KEYRING_CONTROL
	replay 'eval $(gnome-keyring-daemon -s -d -c pkcs11,secrets,ssh 2>/dev/null) && export SSH_AUTH_SOCK && export GNOME_KEYRING_CONTROL'
end

if ! set -q SSH_AUTH_SOCK
	ssh_find_agent a
end
