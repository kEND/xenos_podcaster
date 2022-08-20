import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :xenos_podcaster, XenosPodcaster.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "xenos_podcaster_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :xenos_podcaster, XenosPodcasterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Xym7+sVGyH48KTXjlWp3B0Ws9ASuqktkW5ODKcWU6LUKksVHpoc9tATQYXh2pDsP",
  server: false

# In test we don't send emails.
config :xenos_podcaster, XenosPodcaster.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
