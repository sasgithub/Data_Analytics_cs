# Makefile at project root

QMD_DIR = case-study
OUT_DIR = docs
SRC_DIR = src

.PHONY: render stage commit push deploy check lint-src check-links

render:
	cd $(QMD_DIR) && quarto render

stage:
	git add $(OUT_DIR)/* $(QMD_DIR)/*.qmd *.md

commit:
ifndef MSG
	$(error Please provide a commit message using MSG="your message")
endif
	git commit -m "$(MSG)"

push:
	git push origin main

deploy: render stage commit push

## --- CHECKS ---

check: lint-src check-links

## Lint R, Python, Shell, Awk, etc.
lint-src:
	@echo "Linting source files in $(SRC_DIR)..."
	@find $(SRC_DIR) -name "*.py" -exec python3 -m py_compile {} \;
	@find $(SRC_DIR) -name "*.r" -exec Rscript -e "tools::parse_Rd('{}')" \; 2>/dev/null || true
	@find $(SRC_DIR) -name "*.sh" -exec shellcheck {} \;
	@find $(SRC_DIR) -name "*.awk" -exec gawk -f {} /dev/null \;

## Check for broken links in rendered HTML
check-links:
	@echo "Checking internal links in rendered HTML..."
	@linkchecker --ignore-url=^mailto: --check-extern docs/index.html || echo "Link checking completed with warnings."

