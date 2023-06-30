SHELL := /bin/bash # Use bash syntax

SCRIPT_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_PATH := $(dir $(SCRIPT_PATH))

# If the first argument is "git-flow"...
ifeq (git-flow,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "git-flow"
  GIT_FLOW_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(GIT_FLOW_ARGS):;@:)
endif



.PHONY: git-flow
## add pre and post hooks for git-flow command
GIT_HOOK_PATH := $(shell git config --list | grep "gitflow.path.hooks=" | cut -d "=" -f 2)
git-flow:
	@printf "🐋 \033[1;32m===> Run: git-flow $(GIT_FLOW_ARGS)...\033[0m\n"
	$(eval LASTWORD := $(lastword $(GIT_FLOW_ARGS)))
	@if [[ $(firstword $(GIT_FLOW_ARGS)) = "config" ]]; then \
  	  $(PROJECT_PATH)/git-hooks/git-hooks-config.sh; \
  	else \
  	  $(GIT_HOOK_PATH)/git-flow.sh $(GIT_FLOW_ARGS); \
  	fi
  	$(eval LASTWORD := $(lastword $(GIT_FLOW_ARGS)))


.PHONY: changelog
## generate release change log
GIT_HOOK_PATH := $(shell git config --list | grep "gitflow.path.hooks=" | cut -d "=" -f 2)
changelog:
	@printf "🐋 \033[1;32m===> Generate change log...\033[0m\n"
	$(GIT_HOOK_PATH)/generate-changelog.sh