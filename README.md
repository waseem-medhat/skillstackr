# Skillstackr

**Build a cool portfolio and share it with the world!**

Skillstackr gives you an easy and effective way to build portfolio pages that
are elegant and professional.

![Skillstackr profile demo](https://i.imgur.com/Ph85Q9O.png) 

- **Bring the data and we'll handle the rest**: you only need to enter your
  profile info and add your projects and job experience. A public profile will
  be generated from such data so you don't need to worry about design.

- **Tailor and reuse**: Skillstackr allows (and encourages) you to create a
  many profiles as you need for different roles and companies. Projects and job
  experience data that you add can be reused across multiple profiles as well.

- [COMING SOON] **Guiding you every step of the way**: expert advice will be
  there for you throughout the profile creation process to help you maximize
  the value and effectiveness of your profiles.

## Getting started

The following instructions are for creating a local dev environment:

- Make sure you have Erlang and Elixir installed.

- Start a Postgres database with dev credentials. Here is how to do it with
  Docker:

```bash
docker run -p 5432:5432 -e POSTGRES_USER=skillstackradmin -e POSTGRES_PASSWORD=skillstackradmin --name skillstackr-db postgres
```

- Run `mix setup` to install and setup dependencies.

- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix
  phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

