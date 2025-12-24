#!/bin/sh

zap() {
	for element in "$@"; do
		case "$element" in
			/*) DIR="$element" ;;
			*) DIR="$HOME"/"$element" ;;
		esac
	
		case ":$PATH:" in
			*:"$DIR":*) ;;
			*) PATH="$DIR":"$PATH" ;;
		esac
	done

	export PATH
}


# xdg
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_HOME="$HOME/.local/share"

# wayland environments
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	#    export MOZ_ENABLE_WAYLAND="1"
	#    firefox seems to hate dis?
    export QT_QPA_PLATFORM="wayland"
fi

# clean home
export WINEPREFIX="$XDG_DATA_HOME/wine" #wine
export RUSTUP_HOME="$XDG_DATA_HOME/rustup" #rust
export CARGO_HOME="$XDG_DATA_HOME/cargo" #rust
export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history" #sqlite
export REDISCLI_HISTFILE="$XDG_DATA_HOME/redis/rediscli_history" #redis
export SONARLINT_USER_HOME="$XDG_DATA_HOME/sonarlint" #sonarlint
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history" #node
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc" #node
export PNPM_HOME="$XDG_DATA_HOME/pnpm" #node
export GOPATH="$XDG_DATA_HOME/go" #go
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc" #gtk2
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java" #java
export GNUPGHOME="$XDG_DATA_HOME/gnupg" #gpg
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages" #nuget / dotnet
export LESSHISTFILE="$XDG_CACHE_HOME/less/history" #less
export BUN_INSTALL="$XDG_DATA_HOME/bun" #bun

# global env vars
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export PAGER="/usr/bin/less"
export GPG_TTY="$(tty)"

zap .local/share/bun/bin .local/share/pnpm .local/share/npm/bin .local/share/JetBrains/Toolbox/scripts .local/bin .local/share/go/pkg/bin .dotnet .local/share/cargo/bin .dotnet/tools .local/deno/bin

unset -f zap
