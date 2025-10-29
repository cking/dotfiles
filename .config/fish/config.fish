# interactive extensions
set -e LD_PRELOAD

if status is-interactive
    bind . 'expand-dot-to-parent-directory-path'
end

set -l asdf /opt/asdf-vm/asdf.fish
if not test -f $asdf
	set -l asdf ~/.asdf/asdf.fish
end

if test -f $asdf
	source $asdf
end

set -l ftc /usr/share/doc/find-the-command/ftc.fish
if test -f $ftc
	source $ftc
end
