# Skillstackr

## Getting started

Use the following instructions to set up a local preview of the app. It uses
SQLite so the database setup is handled automatically (but in the Docker case
the database will be in the container).

**With Docker**

* Pull the `wipdev/skillstackr-dev` image and run it locally. You can also
clone this repo and build the image and container from the source code and
Dockerfile.

```bash
docker run -p 4000:4000 --name skillstackr-dev wipdev/skillstackr-dev
```

**Without Docker**

* Make sure you have Erlang and Elixir installed.
* Run `mix setup` to install and setup dependencies.
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix
phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

