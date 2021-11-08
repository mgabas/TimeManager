defmodule TodolistWeb.TeamControllerTest do
  use TodolistWeb.ConnCase

  import Todolist.SchemaFixtures

  alias Todolist.Schema.Team

  @create_attrs %{
    members: ["f7d7d9ef-60d8-4c86-8850-1072432b1c0c", "1df0ce27-4632-41ea-bd74-6c1932ff2185"],
    name: "some name",
    night_team: true,
    manager: "f7d7d9ef-60d8-4c86-8850-1072432b1c0c"
  }
  @update_attrs %{
    members: ["f7d7d9ef-60d8-4c86-8850-1072432b1c0c", "1df0ce27-4632-41ea-bd74-6c1932ff2185"],
    name: "some updated name",
    night_team: false,
    manager: "f7d7d9ef-60d8-4c86-8850-1072432b1c0c"
  }
  @invalid_attrs %{members: nil, name: nil, night_team: nil, manager: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all team", %{conn: conn} do
      conn = get(conn, Routes.team_path(conn, :index))
      assert json_response(conn, 200) != nil
    end
  end

  describe "create team" do
    test "renders team when data is valid", %{conn: conn} do
      conn = post(conn, Routes.team_path(conn, :create), team: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.team_path(conn, :show, id))
      assert %{
               "id" => ^id,
               "members" => ["f7d7d9ef-60d8-4c86-8850-1072432b1c0c", "1df0ce27-4632-41ea-bd74-6c1932ff2185"],
               "name" => "some name",
               "night_team" => true,
               "manager" => "f7d7d9ef-60d8-4c86-8850-1072432b1c0c"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_path(conn, :create), team: @invalid_attrs)
      assert response(conn, 400)
    end
  end

  describe "delete team" do
    setup [:create_team]

    test "deletes chosen team", %{conn: conn, team: team} do
      conn = delete(conn, Routes.team_path(conn, :delete, team.id))
      assert response(conn, 204)
    end
  end

  defp create_team(_) do
    team = team_fixture()
    %{team: team}
  end
end
