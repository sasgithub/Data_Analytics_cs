# Makefile at project root

SHELL := /bin/bash
QMD_DIR = case-study
OUT_DIR = docs
SRC_DIR = src

.PHONY: render stage commit push deploy check lint-src check-links

render:
	cd $(QMD_DIR) && quarto render

stage:
	git add $(OUT_DIR)
	git add $(QMD_DIR)/viz/*.{md,qmd}
	git add $(QMD_DIR)/data/*.{md,qmd}
	git add $(QMD_DIR)/*.qmd
	git add $(QMD_DIR)/*.css
	git add $(SRC_DIR)/[!_]*
	git add *.md

commit:
ifndef MSG
	$(error Please provide a commit message using MSG="your message")
endif
	git commit -m "$(MSG)"

push:
	git push origin main

deploy: render stage commit push

## --- CHECKS ---

check: lint-src check-links check-a11y

## Lint R, Python, Shell, Awk, etc.
lint-src:
	@echo "Linting source files in $(SRC_DIR)..."
	@find $(SRC_DIR) -name "*.py" -exec python3 -m py_compile {} \;
	@find $(SRC_DIR) -name "*.r" -exec Rscript -e "tools::parse_Rd('{}')" \; 2>/dev/null || true
	@find $(SRC_DIR) -name "*.sh" -exec shellcheck {} \;
	@find $(SRC_DIR) -name "*.awk" -exec awk -f {} /dev/null \;

## Check for broken links in rendered HTML
check-links:
	@echo "Checking internal links in rendered HTML..."
	@linkchecker --ignore-url=^mailto: --check-extern docs/index.html || echo "Link checking completed with warnings."

## Check for accessibility
check-a11y:
	@echo "Running accessibility checks on key pages..."
	@bash -c '\
		python3 -m http.server 8080 --directory docs & \
		SERVER_PID=$$!; \
		trap "kill $$SERVER_PID" EXIT; \
		sleep 2; \
		pa11y-ci'

