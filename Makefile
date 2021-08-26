PACMAN := sudo xbps-insall -Sy

.DEFAULT_GOAL := help

# This is taken from https://github.com/masasam/dotfiles
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'	

bootstrap: ## Bootstraps the system (does not copy dots)
	echo "Not implemented"

checks:
	@if [ -z $(PWD) ]; then\
	    echo "Please donot run make as sudo. Bug causes \$$PWD to be not present. See:";\
	    echo "https://unix.stackexchange.com/questions/19983/when-running-sudo-make-install-environment-variables-are-not-passed";\
	    echo "https://jerome-wang.github.io/2015/08/13/pwd-in-sudo-make";\
	    exit 1;\
	fi
	@echo ""

hardcopy: checks $(HOME)/.config .config ## Copies the configs to ~
	echo "Not implemented"

softcopy: checks $(HOME)/.config .config ## Symlinks the configs to ~
	echo "Not implemented"
