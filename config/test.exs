use Mix.Config

# Configure your database
config :cte_161_example, Cte161Example.Repo,
  username: "root",
  password: "root",
  database: "cte_161_example_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cte_161_example, Cte161ExampleWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
