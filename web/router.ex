defmodule AuthSandbox.Router do
  use AuthSandbox.Web, :router

  import AuthSandbox.AuthPlug, only: [ensure_logged_in: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authentication_needed do
    plug :ensure_logged_in
  end


  scope "/", AuthSandbox do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    scope "/users" do
      pipe_through :authentication_needed
      resources "/", UserController
    end

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuthSandbox do
  #   pipe_through :api
  # end
end
