# xdg
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_DATA_HOME $HOME/.local/share

# wayland environments
if [ "$XDG_SESSION_TYPE" = "wayland" ]
    set -gx MOZ_ENABLE_WAYLAND 1
    set -gx QT_QPA_PLATFORM wayland
end

# clean home
set -gx WINEPREFIX $XDG_DATA_HOME/wine #wine
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup #rust
set -gx CARGO_HOME $XDG_DATA_HOME/cargo #rust
set -gx SQLITE_HISTORY $XDG_CACHE_HOME/sqlite_history #sqlite
set -gx REDISCLI_HISTFILE $XDG_DATA_HOME/redis/rediscli_history #redis
set -gx SONARLINT_USER_HOME $XDG_DATA_HOME/sonarlint #sonarlint
set -gx NODE_REPL_HISTORY $XDG_DATA_HOME/node_repl_history #node
set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc #node
set -gx PNPM_HOME $XDG_DATA_HOME/pnpm #node
set -gx GOPATH $XDG_DATA_HOME/go #go
set -gx GTK2_RC_FILES $XDG_CONFIG_HOME/gtk-2.0/gtkrc #gtk2
set -gx _JAVA_OPTIONS "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java" #java
set -gx GNUPGHOME $XDG_DATA_HOME/gnupg #gpg
set -gx NUGET_PACKAGES $XDG_CACHE_HOME/NuGetPackages #nuget / dotnet
set -gx LESSHISTFILE $XDG_CACHE_HOME/less/history #less

# global env vars
set -gx EDITOR /usr/bin/nvim
set -gx VISUAL /usr/bin/nvim
set -gx PAGER /usr/bin/less
set -gx GPG_TTY (tty)
