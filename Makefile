-include .env

setup:
	asdf install && mix deps.get && mix setup

start:
	iex -S mix phx.server
