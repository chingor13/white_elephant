defmodule WhiteElephant.Router do
  use WhiteElephant.Web, :router

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

  scope "/", WhiteElephant do
    pipe_through :browser # Use the default browser stack

    resources "/games", GameController do
      resources "/items", ItemController
    end

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WhiteElephant do
  #   pipe_through :api
  # end
end
