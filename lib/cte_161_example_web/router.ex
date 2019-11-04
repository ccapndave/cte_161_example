defmodule Cte161ExampleWeb.Router do
  use Cte161ExampleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Cte161ExampleWeb do
    pipe_through :api
  end
end
