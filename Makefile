#
.PHONY: default

#
default: help

help:
	@echo 'Use "make <plan>" to build terraform module.'

doc:
	@echo 'Build docs to README ...'
	terraform-docs markdown . > README.md
