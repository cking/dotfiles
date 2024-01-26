complete -c pet -d "Simple command-line snippet manager."

# global flags
complete -c pet -l config -d "config file"
complete -c pet -l debug -d "debug mode"
complete -c pet -l help

# commands
complete -f -c pet -n "__fish_use_subcommand" -a configure -d "Edit config file"

complete -f -c pet -n "__fish_use_subcommand" -a edit -d "Edit snippet file"

complete -f -c pet -n "__fish_use_subcommand" -a exec -d "Run the selected commands"
complete -f -c pet -n "__fish_seen_subcommand_from exec" -l color -d "Enable colorized output (only fzf)"
complete -f -c pet -n "__fish_seen_subcommand_from exec" -l query -s q -d "Initial value for query"

complete -f -c pet -n "__fish_use_subcommand" -a help -d "Help about any command"
set -l commands configure edit exec help list new search sync version
for c in $commands
  complete -f -c pet -n "__fish_seen_subcommand_from help" -a $c -d "Help about $c"
end

complete -f -c pet -n "__fish_use_subcommand" -a list -d "Show all snippets"
complete -f -c pet -n "__fish_seen_subcommand_from list" -l oneline -d "Display snippets in one line"

complete -f -c pet -n "__fish_use_subcommand" -a new -d "Create a new snippet"
complete -f -c pet -n "__fish_seen_subcommand_from new" -l tag -s t -d "Display tag prompt (delimiter: space)"

complete -f -c pet -n "__fish_use_subcommand" -a search -d "Search snippets"
complete -f -c pet -n "__fish_seen_subcommand_from search" -l color -d "Enable colorized output (only fzf)"
complete -f -c pet -n "__fish_seen_subcommand_from search" -l delimiter -s d -d "Use delim as the command delimiter character (default \"; \")"
complete -f -c pet -n "__fish_seen_subcommand_from search" -l query -s q -d "Initial value for query"

complete -f -c pet -n "__fish_use_subcommand" -a sync -d "Sync snippets"
complete -f -c pet -n "__fish_seen_subcommand_from sync" -l upload -s u -d "Upload snippets to gist"

complete -f -c pet -n "__fish_use_subcommand" -a version -d "Print the version number"
