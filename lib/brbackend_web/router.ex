defmodule BrbackendWeb.Router do
  use BrbackendWeb, :router

  pipeline :rate_limited do
    plug BrbackendWeb.RateLimit
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", BrbackendWeb do
    pipe_through :api

    post "/create-user", CreateUserController, :index
    get "/query-user/:id", QueryUserController, :index
    delete "/delete-user/:id", DeleteUserController, :index
  end

end
