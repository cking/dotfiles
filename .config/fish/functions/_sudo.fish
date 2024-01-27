function _sudo

	set -l line $argv

	if not string length -q "$line"
		set line $history[1]
	end

	set -l sudo "su" "-c"
	set -l concat 1

	if type -q sudo
		set sudo "sudo"
		set concat 0
	else if type -q doas
		set sudo "doas"
		set concat 0
	end

	if test $concat = 1
		set line "$line"
	end

	echo Running $sudo $line
	$sudo $line

end
