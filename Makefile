PACMAN := sudo xbps-insall -Sy
CP_SCRIPT := install -Dm755
CP_NOTSCRIPT := install -Dm644

SCRIPTS := $(HOME)/.scripts

.DEFAULT_GOAL := help

# This is taken from https://github.com/masasam/dotfiles
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'	

kitty:
	$(PACMAN) kitty
	mkdir -p $(HOME)/.config/fish
	$(CP_NOTSCRIPT) ${CURDIR}/.config/fish/* $(HOME)/.config/fish

herbstluftwm: kitty
	$(PACMAN) herbstluftwm
	mkdir -p $(HOME)/.config/herbstluftwm
	$(CP_SCRIPT) ${CURDIR}/.config/herbstluftwm/* $(HOME)/.config/herbstluftwm

bootstrap: ## Bootstraps the system (does not copy dots)
	echo "Not implemented"

tree: ## Prints tree of files tracked with yadm/git
	@git-tree --root \$$HOME --noreport 2> /dev/null || { >&2 echo "'git-tree' not found, please make sure to setup scripts first"; exit 1; }
	
checks:
	@if [ -z $(PWD) ]; then\
	    echo "Please donot run make as sudo. Bug causes \$$PWD to be not present. See:";\
	    echo "https://unix.stackexchange.com/questions/19983/when-running-sudo-make-install-environment-variables-are-not-passed";\
	    echo "https://jerome-wang.github.io/2015/08/13/pwd-in-sudo-make";\
	    exit 1;\
	fi

