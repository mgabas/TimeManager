defmodule TodolistWeb.ClocksController do
  use TodolistWeb, :controller

  require Logger
  require UUID
  alias Todolist.Schema
  alias Todolist.Schema.Clocks

  action_fallback TodolistWeb.FallbackController

  def create(conn, params) do
    Logger.debug "Ici : #{inspect(params)}"
    map = %{"users" => params["userid"]}
    if !Map.has_key?(params, "userid") ||
        UUID.info(params["userid"]) === {:error, "Invalid argument; Not a valid UUID: #{map["users"]}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    else
      data = if Map.has_key?(params, "clocks") do
      Enum.reduce([map, params["clocks"]], &Map.merge/2)
      else
        map
    end
    if (Schema.get_clocks_by_userid(params["userid"]) !== nil) do
      Logger.debug "Pass in..."
      conn |> put_status(400) |> send_resp(400, "Bad request, a clock already exists for this user")
    else
      Logger.debug "Pass after"
      with {:ok, %Clocks{} = clocks} <- Schema.create_clocks(data) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.clocks_path(conn, :show, clocks))
        |> render("show.json", clocks: clocks)
    end
    end
    end
  end

  def show(conn, %{"userid" => id}) do
    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    end
    clocks = Schema.get_clocks_by_userid(id)
    if clocks === nil do
      conn |> put_status(400) |> send_resp(400, "Bad request, unknown UUID")
    end
    render(conn, "show.json", clocks: clocks)
  end

  def getClockByToken(conn, %{"token" => token}) do
    if Todolist.JwtAuthToken.verifyToken(token) === False do
      conn |> put_status(400) |> send_resp(401, "Unauthorized, wrong token")
    else
      user = Schema.get_user_by_token(token)
      if user === nil do
        conn |> put_status(400) |> send_resp(400, "Bad request, unknown user or wrong token")
      else
        clock = Schema.get_clocks_by_userid(user.id)
        if clock === nil do
          conn |> put_status(400) |> send_resp(400, "Bad request, no clock for this user")
        else
          render(conn, "show.json", clocks: clock)
        end
      end
    end
  end

  def updateStatus(conn, params) do
    if !Map.has_key?(params, "userid") ||
       !Map.has_key?(params, "status") ||
       !Map.has_key?(params, "time") ||
         params |> map_size !== 3 ||
         UUID.info(params["userid"]) === {:error, "Invalid argument; Not a valid UUID: #{params["userid"]}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, wrong params sent to the API")
    else
    userid = params["userid"]
    clock = Schema.get_clocks_by_userid(userid)
    if clock === nil do
      conn |> put_status(400) |> send_resp(400, "Bad request, wrong params sent to the API")
    else
      with {:ok, %Clocks{} = clocks} <- Schema.update_clocks(clock, params) do
        render(conn, "show.json", clocks: clocks)
      end
    end
    end
  end

end
