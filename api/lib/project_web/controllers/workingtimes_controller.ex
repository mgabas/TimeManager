defmodule TodolistWeb.WorkingtimesController do
  use TodolistWeb, :controller

  require Logger
  alias Todolist.Schema
  alias Todolist.Schema.Workingtimes

  action_fallback TodolistWeb.FallbackController

  def show(conn, params) do
    id = params["userid"]

    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    end

    { workingtimes, shouldRenderIndex } = if Map.has_key?(params, "start") && Map.has_key?(params, "end") && params |> map_size == 3 do
      start_ = params["start"]
      end_ = params["end"]
      { Schema.get_workingtimes_by_start_end(id, start_, end_), false }
    else
      { Schema.get_workingtimes_by_userid(id), true }
    end
    if workingtimes === nil do
        conn |> put_status(400) |> send_resp(400, "Bad request, unknown UUID or wrong username/email pair")
      else
        if (shouldRenderIndex) do
          render(conn, "index.json", workingtimes: workingtimes)
        else
          render(conn, "show.json", workingtimes: workingtimes)
        end
    end
  end

  def getWorkingTimeById(conn,  %{"id" => id}) do
    workingtimes = Schema.get_workingtimes_by_work_id(id)
    if (workingtimes === nil) do
      conn |> put_status(400) |> send_resp(400, "Bad request, unknown UUID or wrong username/email pair")
    else
      render(conn, "show.json", workingtimes: workingtimes)
    end
  end

  def getWorkingTimeByToken(conn, %{"token" => token}) do
    if Todolist.JwtAuthToken.verifyToken(token) === False do
      conn |> put_status(400) |> send_resp(401, "Unauthorized, wrong token")
    else
      user = Schema.get_user_by_token(token)
      if user === nil do
        conn |> put_status(400) |> send_resp(400, "Bad request, unknown user or wrong token")
      else
        workingtimes = Schema.get_workingtimes_by_userid(user.id)
        if workingtimes === nil do
          conn |> put_status(400) |> send_resp(400, "Bad request, user have no workingtimes")
        else
          render(conn, "index.json", workingtimes: workingtimes)
        end
      end
    end
  end

  def getAllWorkingTimes(conn, _params) do
    workingtimes = Schema.get_all_working_times()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"workingtimes" => workingtimes_params}) do
    if workingtimes_params["users"] === nil || workingtimes_params["start"] === nil || workingtimes_params["end"] === nil do
      conn |> put_status(400) |> send_resp(400, "Bad request, wrong params")
    else
      with {:ok, %Workingtimes{} = workingtimes} <- Schema.create_workingtimes(workingtimes_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.workingtimes_path(conn, :show, workingtimes))
        |> render("show.json", workingtimes: workingtimes)
      end
    end
  end

  def update(conn, %{"id" => id, "workingtimes" => workingtimes_params}) do
    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    end
    workingtimes = Schema.get_workingtimes(id)

    if workingtimes === nil do
      conn |> put_status(400) |> send_resp(400, "Bad request, unknown UUID")
    end
    with {:ok, %Workingtimes{} = workingtimes} <- Schema.update_workingtimes(workingtimes, workingtimes_params) do
      render(conn, "show.json", workingtimes: workingtimes)
    end

    Logger.debug "working time: #{inspect(workingtimes)}"
  end

  def delete(conn, %{"id" => id}) do
    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    end
    workingtimes = Schema.get_workingtimes(id)

    if workingtimes === nil do
      conn |> put_status(400) |> send_resp(400, "Bad request, unknown UUID")
    end
    with {:ok, %Workingtimes{}} <- Schema.delete_workingtimes(workingtimes) do
      send_resp(conn, :no_content, "")
    end
  end

end
