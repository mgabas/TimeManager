defmodule TodolistWeb.Router do
  use TodolistWeb, :router

  pipeline :api do
    plug CORSPlug, origin: ["*"]
    plug :accepts, ["json"]
  end

  scope "/api", TodolistWeb do
    pipe_through :api
    # Working times routes
    resources "/workingtimes", WorkingtimesController, except: [:new, :edit, :create, :index, :show, :update]
    post "/workingtimes/", WorkingtimesController, :create
    get "/workingtimes/:userid", WorkingtimesController, :show
    get "/workingtimes/id/:id", WorkingtimesController, :getWorkingTimeById
    get "/workingtimes/", WorkingtimesController, :getAllWorkingTimes
    put "/workingtimes/:id", WorkingtimesController, :update
    get "/workingtimes/token/:token", WorkingtimesController, :getWorkingTimeByToken
    # Users routes
    resources "/users", UsersController, except: [:new, :edit]
    get "/users/members/:id", UsersController, :getTeamMembersByTeamId
    post "/users/sign-in", UsersController, :signInUser
    post "/users/logout", UsersController, :logoutUser
    get "/users/token/:token", UsersController, :getUserByToken
    # Clocks routes
    post "/clocks/:userid", ClocksController, :create
    get "/clocks/:userid", ClocksController, :show
    get "/clocks/token/:token", ClocksController, :getClockByToken
    put "/clocks", ClocksController, :updateStatus
    # Charts routes
    get "/charts/:user", ChartsController, :show
    get "/charts/token/:token", ChartsController, :getChartsByToken
    post "/charts/:user", ChartsController, :create
    put "/charts/", ChartsController, :update
    # Team routes
    resources "/teams/", TeamController, except: [:new, :edit]
    get "/teams/user/:userid", TeamController, :getTeamByUserId
    get "/teams/token/:token", TeamController, :getTeamByToken
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TodolistWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
