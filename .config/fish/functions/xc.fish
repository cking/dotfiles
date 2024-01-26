function xc -d "xc: extract file"
	set -l spec "o/outdir="
	argparse -N 1 -X 1 $spec -- $argv
	or return

	set -l archive $argv[1]

	if test ! -f $archive
		echo "$archive not found, or not a file"
		return 2
	end

	set -l outdir $_flag_o
	if test -z $outdir
		set outdir .
	end

	if string match -q -r '\.tar\.[^\/]*$' $archive
		echo tar xaf $archive -C $outdir
		tar xaf $archive -C $outdir
	else if string match -q -r '\.7z$' $archive
		echo 7z x -o $outdir $archive
		7z x -o $outdir $archive
	else if string match -q -r '\.zip$' $archive
		echo unzip $archive -d $outdir
		unzip $archive -d $outdir
	else
		echo "Unsupported archive..."
		return -1
	end
end