defmodule TodolistWeb.ChartsController do
  use TodolistWeb, :controller
  require Logger

  alias Todolist.Schema
  alias Todolist.Schema.Charts

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    charts = Schema.list_charts()
    render(conn, "index.json", charts: charts)
  end

  def create(conn, params) do
    if (Map.has_key?(params, "user") === false ||
          UUID.info(params["user"]) === {:error, "Invalid argument; Not a valid UUID: #{params["user"]}"} ||
          Schema.get_charts_by_user_id(params["user"]) !== nil) do
      conn |> put_status(400) |> send_resp(400, "Bad request, a chart already exists for this user")
    else
      with {:ok, %Charts{} = charts} <- Schema.create_charts(params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.charts_path(conn, :show, charts))
        |> render("show.json", charts: charts)
      end
    end
  end

  def show(conn, %{"user" => user}) do
    charts = Schema.get_charts_by_user_id(user)
    render(conn, "show.json", charts: charts)
  end

  def getChartsByToken(conn, %{"token" => token}) do
    if Todolist.JwtAuthToken.verifyToken(token) === False do
      conn |> put_status(400) |> send_resp(401, "Unauthorized, wrong token")
    else
      user = Schema.get_user_by_token(token)
      if user === nil do
        conn |> put_status(400) |> send_resp(400, "Bad request, unknown user or wrong token")
      else
        chart = Schema.get_charts_by_user_id(user.id)
        if chart === nil do
          conn |> put_status(400) |> send_resp(400, "Bad request, no chart for this user")
        else
          render(conn, "show.json", charts: chart)
        end
      end
    end
  end

  def update(conn, %{"charts" => charts_params}) do
    charts = Schema.get_charts_by_user_id(charts_params["user"])

    Logger.debug "Here we are in update"
    with {:ok, %Charts{} = charts} <- Schema.update_charts(charts, charts_params) do
      render(conn, "show.json", charts: charts)
    end
  end

  def delete(conn, %{"id" => id}) do
    charts = Schema.get_charts!(id)

    with {:ok, %Charts{}} <- Schema.delete_charts(charts) do
      send_resp(conn, :no_content, "")
    end
  end
end
