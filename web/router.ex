defmodule Lancer.Router do
  use Lancer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Lancer.Auth, repo: Lancer.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Lancer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/about", PageController, :about
    get "/contact", PageController, :contact
    get "/faq", PageController, :faq
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", Lancer do
    pipe_through [:browser, :authenticate_user]

    resources "/projects", ProjectController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Lancer do
  #   pipe_through :api
  # end
end
