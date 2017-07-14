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

    get "/", ProjectController, :index
    get "/search", ProjectController, :search
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/jobs", ProjectController, only: [:show]
  end

  scope "/", Lancer do
    pipe_through [:browser, :authenticate_user]

    put "/award-project/:id", ProjectController, :award_proposal

    resources "/projects", ProjectController, except: [:index, :show] do
      resources "/proposals", ProposalController, except: [:index, :show]
    end
    resources "/users", UserController, except: [:show, :index]
  end

  scope "/manage", Lancer do
    pipe_through [:browser, :authenticate_user]

    get "/projects", ProjectController, :manage_projects
  end

  # Other scopes may use custom stacks.
  # scope "/api", Lancer do
  #   pipe_through :api
  # end
end
