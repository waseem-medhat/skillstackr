-include .env

setup:
	${HOME}/.asdf/bin/asdf install && mix deps.get

start:
	iex -S mix phx.server
