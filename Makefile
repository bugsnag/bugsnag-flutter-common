FLUTTER_BIN?=flutter
PRESET_VERSION=$(shell cat VERSION)

all: format lint

.PHONY: clean bump format lint stage

clean:
	cd packages/bugsnag-flutter-bridge && $(FLUTTER_BIN) clean --suppress-analytics
	rm -rf staging

bump: ## Bump the version numbers to $VERSION
ifeq ($(VERSION),)
	@$(error VERSION is not defined. Run with `make VERSION=number bump`)
endif
	@echo $(VERSION) > VERSION
	sed -i '' "s/## TBD/## $(VERSION) ($(shell date '+%Y-%m-%d'))/" CHANGELOG.md
	sed -i '' "s/^version: .*/version: $(VERSION)/" packages/bugsnag-flutter-bridge/pubspec.yaml

BSG_FLUTTER_VERSION:=$(shell grep 'version: ' packages/bugsnag-flutter-bridge/pubspec.yaml | grep -o '[0-9].*')
staging/%:
	mkdir -p staging/$*
	cd packages/$* && cp -a . ../../staging/$*
	rm -f staging/$*/pubspec.lock
	cp LICENSE staging/$*/.
	cp -n README.md staging/$*/.
	cp CHANGELOG.md staging/$*/.
	sed -i '' -e '1,2d' staging/$*/CHANGELOG.md

stage: clean staging/bugsnag-flutter-bridge

publish_dry/%:
	cd staging/$* && $(FLUTTER_BIN) pub publish --dry-run
	
publish_dry: publish_dry/bugsnag-flutter-bridge

format:
	$(FLUTTER_BIN) format packages/bugsnag-flutter-bridge

lint:
	cd packages/bugsnag-flutter-bridge && $(FLUTTER_BIN) analyze --suppress-analytics

prerelease: bump stage publish_dry ## Generates a PR for the $VERSION release
ifeq ($(VERSION),)
	@$(error VERSION is not defined. Run with `make VERSION=number prerelease`)
endif
	rm -rf staging
	@git checkout -b release-v$(VERSION)
	@git add packages/bugsnag-flutter-bridge/pubspec.yaml CHANGELOG.md VERSION
	@git diff --exit-code || (echo "you have unstaged changes - Makefile may need updating to `git add` some more files"; exit 1)
	@git commit -m "Release v$(VERSION)"
	@git push origin release-v$(VERSION)
	@open "https://github.com/bugsnag/bugsnag-flutter-common/compare/main...release-v$(VERSION)?expand=1&title=Release%20v$(VERSION)&body="$$(awk 'start && /^## /{exit;};/^## /{start=1;next};start' CHANGELOG.md | hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g')

release: stage publish_dry ## Releases the current main branch as $VERSION
	@git fetch origin
ifneq ($(shell git rev-parse --abbrev-ref HEAD),main) # Check the current branch name
	@git checkout main
	@git rebase origin/main
endif
ifneq ($(shell git diff origin/main..main),)
	$(error you have unpushed commits on the main branch)
endif
	@git tag v$(PRESET_VERSION)
	@git push origin v$(PRESET_VERSION)
	@git checkout next
	@git rebase origin/next
	@git merge main
	@git push origin next
	# Prep GitHub release
	# We could technically do a `hub release` here but a verification step
	# before it goes live always seems like a good thing
	@open 'https://github.com/bugsnag/bugsnag-flutter-common/releases/new?title=v$(PRESET_VERSION)&tag=v$(PRESET_VERSION)&body='$$(awk 'start && /^## /{exit;};/^## /{start=1;next};start' CHANGELOG.md | hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g')
	cd staging/bugsnag-flutter-bridge && $(FLUTTER_BIN) pub publish
	rm -rf staging
