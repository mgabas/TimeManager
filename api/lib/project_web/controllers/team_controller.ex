defmodule TodolistWeb.TeamController do
  use TodolistWeb, :controller
  require Logger
  alias Todolist.Schema
  alias Todolist.Schema.Team

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    team = Schema.list_team()
    render(conn, "index.json", team: team)
  end

  def create(conn, %{"team" => team_params}) do
    Logger.debug "MAIS ICI PUTAIN DE MERDE DE LANGAGE"
    if team_params["name"] !== nil &&
       team_params["members"] !== nil &&
       team_params["manager"] !== nil &&
       team_params["night_team"] !== nil do
          with {:ok, %Team{} = team} <- Schema.create_team(team_params) do
          conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.team_path(conn, :show, team))
            |> render("show.json", team: team)
          end
    else
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    end
  end

  def show(conn, %{"id" => id}) do
    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    else
      team = Schema.get_team(id)
      if team === nil do
        conn |> put_status(400) |> send_resp(400, "Bad request, the given id is not associated to a current team")
      else
        render(conn, "show.json", team: team)
      end
    end
  end

  def getTeamByUserId(conn, %{"userid" => userid}) do
    if UUID.info(userid) === {:error, "Invalid argument; Not a valid UUID: #{userid}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    else
      user = Schema.get_users(userid)
      all_teams = Schema.get_all_team()
      members_id_map = all_teams
                    |> Enum.filter(fn(team) -> Logger.debug "Before first filter: #{inspect(team)}"; team.members != nil end)
                    |> Enum.map(fn(team) -> Logger.debug "In the first map: #{inspect(team)}"; %{:members => team.members, :id => team.id} end)
                    |> Enum.filter(fn(map) -> Enum.any?(map[:members], fn(uuid) -> uuid === userid end) end)
                    |> Enum.map(fn(team) -> Logger.debug "Logger in #{inspect(team[:id])}"; team[:id] end)
      Logger.debug "Last debug : #{inspect(members_id_map)}"
      if length(members_id_map) <= 0 do
        conn |> put_status(400) |> send_resp(400, "Bad request, the given id is not associated to a current team")
      else
        render(conn, "show.json", team: Schema.get_team(List.first(members_id_map)))
      end
    end
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    else
      if team = Schema.get_team(id) === nil do
        conn |> put_status(400) |> send_resp(400, "Bad request, the given id is not associated to a current team")
      else
        with {:ok, %Team{} = team} <- Schema.update_team(team, team_params) do
          render(conn, "show.json", team: team)
        end
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    else
      team = Schema.get_team(id)
      if team === nil do
        conn |> put_status(400) |> send_resp(400, "Bad request, the given id is not associated to a current team")
      else
      Logger.debug "Here is the team heeere: #{inspect(team)}"
        with {:ok, %Team{}} <- Schema.delete_team(team) do
          send_resp(conn, :no_content, "")
        end
      end
    end
  end

end
