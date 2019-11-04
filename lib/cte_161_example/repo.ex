defmodule Cte161Example.Repo do
  use Ecto.Repo,
    otp_app: :cte_161_example,
    adapter: Ecto.Adapters.MyXQL
end
