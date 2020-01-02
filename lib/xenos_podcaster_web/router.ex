defmodule XenosPodcasterWeb.Router do
  use XenosPodcasterWeb, :router

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

  scope "/", XenosPodcasterWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/feed/:series", PageController, :feed
  end

  # Other scopes may use custom stacks.
  # scope "/api", XenosPodcasterWeb do
  #   pipe_through :api
  # end
end
