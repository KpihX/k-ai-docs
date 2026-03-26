serve:
	npx docsify-cli serve .

status:
	git status --short

push:
	branch="$$(git branch --show-current)"; \
	git push github "$$branch" && git push gitlab "$$branch"
