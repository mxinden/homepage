build:
	docker run --rm -it -v $(shell pwd):/src klakegg/hugo:0.101.0

serve:
	docker run --init --rm -it -v $(shell pwd):/src --network host klakegg/hugo:0.101.0 server

resume_pdf:
	pandoc content/resume/_index.md --template=content/resume/template.tex --pdf-engine=xelatex -o index.pdf
