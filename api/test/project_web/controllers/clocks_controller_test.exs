defmodule TodolistWeb.ClocksControllerTest do
  use TodolistWeb.ConnCase

  import Todolist.SchemaFixtures

  alias Todolist.Schema.Clocks

  @create_attrs %{
    status: true,
    time: ~U[2021-10-25 11:31:00Z],
    users: "1df0ce27-4632-41ea-bd74-6c1932ff2185"
  }
  @update_attrs %{
    status: false,
    time: ~U[2021-10-26 11:31:00Z],
    users: "3ad97a32-75d5-401c-892a-e134b410b32c"
  }
  @invalid_attrs %{status: nil, time: nil, users: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create clocks" do
    test "renders clocks when data is valid", %{conn: conn} do
      conn = post(conn, Routes.clocks_path(conn, :create, "1df0ce27-4632-41ea-bd74-6c1932ff2185"), clocks: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.clocks_path(conn, :show, "1df0ce27-4632-41ea-bd74-6c1932ff2185"))
      assert %{
               "status" => true,
               "time" => "2021-10-25T11:31:00Z",
               "users" => "1df0ce27-4632-41ea-bd74-6c1932ff2185"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.clocks_path(conn, :create, "1df0ce27-4632-41ea-bd74"), clocks: @invalid_attrs)
      assert response(conn, 400)
    end
  end

  describe "update clocks" do
    setup [:create_clocks]

    test "renders clocks when data is valid", %{conn: conn} do
      conn = put(conn, Routes.clocks_path(conn, :updateStatus), clocks: @update_attrs)
      assert response(conn, 400)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = put(conn, Routes.clocks_path(conn, :updateStatus), clocks: @invalid_attrs)
      assert response(conn, 400)
    end
  end

  defp create_clocks(_) do
    clocks = clocks_fixture()
    %{clocks: clocks}
  end
end
