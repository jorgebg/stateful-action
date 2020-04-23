main.js post.js: _template.js scripts/main.sh scripts/post.sh
	@for name in main post; do \
		echo "const script = \`" > $$name.js ; \
		cat scripts/$$name.sh >> $$name.js ; \
		echo "\`;" >> $$name.js ; \
		cat _template.js >> $$name.js ; \
	done

.git/hooks/pre-commit: pre-commit
	cp pre-commit $@