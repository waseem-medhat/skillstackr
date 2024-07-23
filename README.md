# Skillstackr

**Build a cool portfolio and share it with the world!**

Skillstackr gives you an easy and effective way to build portfolio pages that
are elegant and professional.

![Skillstackr profile demo](https://i.imgur.com/Ph85Q9O.png) 

- **Bring the data and we'll handle the rest**: you only need to enter your
profile info and add your projects and job experience. A public profile will be
generated from such data so you don't need to worry about design.

- **Tailor and reuse**: Skillstackr allows (and encourages) you to create as
many profiles as you need for different roles and companies.

- [COMING SOON] **Guiding you every step of the way**: expert advice will be
there for you throughout the profile creation process to help you maximize
the value and effectiveness of your profiles.

## Getting started

Use the following instructions to set up a local preview of the app. It uses
SQLite so the database setup is handled automatically (but in the Docker case
the database will be in the container).

**With Docker**

* Create an image from the dev Dockerfile.

```bash
docker build --tag skillstackr-dev -f Dockerfile.dev .
```

* Run a container that exposes port 4000.

```bash
docker run -p 4000:4000 skillstackr-dev
```

**Without Docker**

* Make sure you have Erlang and Elixir installed.
* Run `mix setup` to install and setup dependencies.
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix
phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

