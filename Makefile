-include .env

setup:
	${HOME}/.asdf/bin/asdf install && ${HOME}/.asdf/shims/mix deps.get

start:
	iex -S mix phx.server
