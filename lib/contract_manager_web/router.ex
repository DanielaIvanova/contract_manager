defmodule ContractManagerWeb.Router do
  use ContractManagerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ContractManagerWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/registrations", UserController, only: [:new, :create])

    get("/sign-in", SessionController, :new)
    post("/sign-in", SessionController, :create)
    delete("/sign-out", SessionController, :delete)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ContractManagerWeb do
  #   pipe_through :api
  # end
end
