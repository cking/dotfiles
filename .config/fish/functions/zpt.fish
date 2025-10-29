function zpt
	
	set -l UID (id -u)
	set -l zp "/run/user/$UID/zp.lst"

	set -l target (realpath .)
	if test (count $argv) -gt 0
		set -l tf $argv[1]
		if test -d $tf
			set target $tf
		else
			echo "$tf is not a valid directory"
		end
	end

	for line in (cat $zp)
		set -l xf (string split -m 2 -n ' ' $line)
		set -l x $xf[1]
		set -l f $xf[2]
		
		set -l cmd "cp"
		if test $x = 1
			set cmd "mv"
		end

		$cmd "$f" "$target"		
	end

	rm $zp

end
