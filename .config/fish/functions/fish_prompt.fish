function fish_prompt
    set -lx exit_code $status # Export for __fish_print_pipestatus.

    # path
    set -g fish_prompt_pwd_dir_length 2
    printf "%s%s" (set_color blue) (prompt_pwd)

    # vcs 
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showcolorhints 1
    set -g __fish_git_prompt_color_prefix cyan
    set -g __fish_git_prompt_color_suffix cyan
    set -g __fish_git_prompt_char_dirtystate "✚ " # it clips into number without space
    set -l vcs_out (string trim (fish_vcs_prompt))
    if string length -q -- $vcs_out
        printf "%s" $vcs_out
    end

    # run duration
    if test -n "$CMD_DURATION" -a "$CMD_DURATION" -gt (math --scale=0 "3 * 1000")
        set --local time
        
        set --local days (math --scale=0 "$CMD_DURATION / 86400000")
        test "$days" -gt 0; and set --append time (printf "%sd" $days)
        
        set --local hours (math --scale=0 "$CMD_DURATION / 3600000 % 24")
        test "$hours" -gt 0; and set --append time (printf "%sh" $hours)
        
        set --local minutes (math --scale=0 "$CMD_DURATION / 60000 % 60")
        test "$minutes" -gt 0; and set --append time (printf "%sm" $minutes)
        
        set --local seconds (math --scale=0 "$CMD_DURATION / 1000 % 60")
        set --append time (printf "%ss" $seconds)
        printf " %s<%s>" (set_color brblack) $time
    end

    if not contains "$exit_code" 0 141
        set -l exit_string (fish_status_to_signal $exit_code)
        if test -n "$exit_string"
            set exit_string $exit_code
        end
        printf " %s[%s]" (set_color -o red) $exit_string
    end

    # new line
    echo

    # user@host
    printf "%s " (prompt_login)

    # root
    if fish_is_root_user
        set_color -r magenta
    else
        set_color -o magenta
    end

	printf "❯%s " (set_color normal)
end
