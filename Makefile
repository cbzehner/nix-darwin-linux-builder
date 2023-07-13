.DEFAULT_GOAL := virtual-machine

help: ## Display this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

virtual-machine: ## Start a Linux virtual machine for development on MacOS
	@echo "Starting Linux VM..."
	@echo "Run `shutdown -h now` to stop the VM."
	nix run .#linuxBuilder

nix-reload: ## Reload the nix environment
	direnv reload
