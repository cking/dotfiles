function zmv
	
	set -l UID (id -u)
	set -l zp "/run/user/$UID/zp.lst"

	argparse "a/append" -- $argv 
	or return

	if not set -q _flag_append
		rm $zp 2>/dev/null or true
	end

	for f in $argv
		set -l f (realpath $f)
		echo "1 $f" >> $zp
	end

end
