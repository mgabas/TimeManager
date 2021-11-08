defmodule TodolistWeb.WorkingtimesControllerTest do
  use TodolistWeb.ConnCase

  import Todolist.SchemaFixtures

  alias Todolist.Schema.Workingtimes

  @create_attrs %{
    end: "2021-10-25T12:59:00Z",
    start: "2021-10-26T12:59:00Z",
    users: "1df0ce27-4632-41ea-bd74-6c1932ff2185"
  }
  @update_attrs %{
    end: "2021-10-25T12:59:01Z",
    start: "2021-10-26T12:59:01Z",
    users: "1df0ce27-4632-41ea-bd74-6c1932ff2185"
  }
  @invalid_attrs %{end: nil, start: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "getAllWorkingTime" do
    test "lists all workingtimes", %{conn: conn} do
      conn = get(conn, Routes.workingtimes_path(conn, :getAllWorkingTimes))
      assert json_response(conn, 200) != nil
    end
  end

  describe "create workingtimes" do
    test "renders workingtimes when data is valid", %{conn: conn} do
      conn = post(conn, Routes.workingtimes_path(conn, :create), workingtimes: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.workingtimes_path(conn, :getWorkingTimeById, id))
      assert %{
               "id" => ^id,
               "end" => "2021-10-25T12:59:00Z",
               "start" => "2021-10-26T12:59:00Z",
               "users" => "1df0ce27-4632-41ea-bd74-6c1932ff2185"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.workingtimes_path(conn, :create), workingtimes: @invalid_attrs)
      assert response(conn, 400)
    end
  end

  describe "delete workingtimes" do
    setup [:create_workingtimes]

    test "deletes chosen workingtimes", %{conn: conn, workingtimes: workingtimes} do
      conn = delete(conn, Routes.workingtimes_path(conn, :delete, workingtimes.id))
      assert response(conn, 204)
    end
  end

  defp create_workingtimes(_) do
    workingtimes = workingtimes_fixture()
    %{workingtimes: workingtimes}
  end
end
