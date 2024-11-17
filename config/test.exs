import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :skillstackr, Skillstackr.Repo,
  database: Path.expand("../skillstackr_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :skillstackr, SkillstackrWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "5NxFiqr72x4ejLJvSt1Oh/eMibQYltiQJbYamFBix2mgEfsy86MnWCAoCKzSy1SM",
  server: false

# In test we don't send emails
config :skillstackr, Skillstackr.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :ex_aws,
  access_key_id: [{:awscli, "skillstackrdev", 30}],
  secret_access_key: [{:awscli, "skillstackrdev", 30}],
  awscli_auth_adapter: ExAws.STS.AuthCache.AssumeRoleCredentialsAdapter
