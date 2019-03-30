defmodule EtherflowWeb.Router do
  use EtherflowWeb, :router

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

  scope "/", EtherflowWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", EtherflowWeb do
    pipe_through :api

    get "/match", PageController, :match    
    post "/query", PageController, :query    
  end
end
