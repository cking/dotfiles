function expand-dot-to-parent-directory-path -d 'expand ... to ../..'
	# Get command line, up to cursor
	set -l cmd (commandline --cut-at-cursor)

	# Match last line
	switch $cmd[-1]

		# If the command line is just two dots, we want to expand
		case '..'
			commandline --insert '/..'

		# If the command line starts with 'cd' and ends with two dots, we want to expand
		case 'cd *..'
			commandline --insert '/..'

		# If the command line starts and ends with two dots, we want to expand
		case '..*..'
			commandline --insert '/..'

		# In all other cases, just insert a dot
		case '*'
			commandline --insert '.'
	end
end

