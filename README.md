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

## Tech Stack

- [Elixir](https://elixir-lang.org/): main language
- [Phoenix](https://www.phoenixframework.org/): backend framework
- [LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html):
server-driven UI interactivity
- [PostgreSQL](https://www.postgresql.org/): database
- [TailwindCSS](https://tailwindcss.com/): UI styling
- [Preline](https://www.preline.co/): UI component library
- [Simple Icons](https://simpleicons.org/): technology/brand icons

## Contributing

Contributions are welcome! Feel free to open issues and PRs.

- The project includes a CI pipeline that runs checks for formatting and
testing via Mix and linting via Credo. Please ensure all checks pass in
submitted PR(s).

- To run these checks locally, you can use the following commands:

```bash
# check formatting without modifying files
mix format --check-formatted

# format the codebase
mix format

# run all tests
mix test

# run credo
mix credo
```
