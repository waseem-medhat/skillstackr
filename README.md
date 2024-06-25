# Skillstackr

## Getting started

**With Docker**

  * To have a local preview of the website via Docker you can pull the
  `wipdev/skillstackr-dev` image and run it locally. You can also clone this
  repo and build the image and container from the source code and Dockerfile

```bash
docker run -p 4000:4000 --name skillstackr-dev wipdev/skillstackr-dev
```

**Without Docker**

  * Make sure you have Erlang and Elixir installed.
  * Run `mix setup` to install and setup dependencies.
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

