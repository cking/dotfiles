complete -c shotman -s c -l capture -d 'Capture the given target into a screenshot' -r -f -a "{window	'The currently active window',output	'The entirety of the currently active output',region	'A custom region (chosen interactively)'}"
complete -c shotman -s i -l image-editor -d 'Use `PROG` as an image editor' -r
complete -c shotman -s v -l verbose -d 'Log using specified verbosity' -r
complete -c shotman -s a -l anchor -d 'Anchor thumbnail to this edge of the screen' -r
complete -c shotman -s C -l copy -d 'Automatically copy to clipboard'
complete -c shotman -l unstable-copy-as-uri -d 'When copying to clipboard, also offer mime type `text/uri-list'
complete -c shotman -s h -l help -d 'Print help (see more with \'--help\')'
complete -c shotman -s V -l version -d 'Print version'
