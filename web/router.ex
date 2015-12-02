defmodule WhiteElephant.Router do
  use WhiteElephant.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    # plug :ensure_logged_in
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WhiteElephant do
    pipe_through :browser # Use the default browser stack

    get "/play/:game_code", PlayController, :play

    get "/", PageController, :index
  end

  scope "/admin", WhiteElephant do
    pipe_through [:browser, :admin]
    resources "/games", GameController do
      resources "/items", ItemController, except: [:index, :show]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", WhiteElephant do
  #   pipe_through :api
  # end
end
