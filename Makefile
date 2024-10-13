include .env

setup:
	asdf install && mix deps.get

start:
	iex -S mix phx.server
