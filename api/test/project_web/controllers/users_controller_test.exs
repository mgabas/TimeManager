defmodule TodolistWeb.UsersControllerTest do
  use TodolistWeb.ConnCase

  import Todolist.SchemaFixtures

  alias Todolist.Schema.Users

  @create_attrs %{
    email: "test@test.rs",
    username: "test",
    job: "Employee",
    password: "pass",
    token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6MTYzNjEzNzY1MSwiaWF0IjoxNjM2MTMwNDUxLCJpc3MiOiJKb2tlbiIsImp0aSI6IjJxcWI3dWhmZXMxb3FrZXRubzAwMDIzNSIsIm5iZiI6MTYzNjEzMDQ1MX0.FeUydAJmivwsjPeg0O2WlZkJuHbl28gKG398YxHlkdg"
  }
  @update_attrs %{
    email: "test2@test2.rs",
    username: "test2",
    job: "Manager",
    password: "pass",
    token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6MTYzNjEzNzY1MSwiaWF0IjoxNjM2MTMwNDUxLCJpc3MiOiJKb2tlbiIsImp0aSI6IjJxcWI3dWhmZXMxb3FrZXRubzAwMDIzNSIsIm5iZiI6MTYzNjEzMDQ1MX0.FeUydAJmivwsjPeg0O2WlZkJuHbl28gKG398YxHlkdg"
  }
  @invalid_attrs %{email: nil, username: nil, job: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.users_path(conn, :index))
      assert json_response(conn, 200) != nil
    end
  end

  describe "create users" do
    test "renders users when data is valid", %{conn: conn} do
      conn = post(conn, Routes.users_path(conn, :create, %{username: "test", email: "test@test.rs", job: "Employee", password: "pass", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6MTYzNjEzNzY1MSwiaWF0IjoxNjM2MTMwNDUxLCJpc3MiOiJKb2tlbiIsImp0aSI6IjJxcWI3dWhmZXMxb3FrZXRubzAwMDIzNSIsIm5iZiI6MTYzNjEzMDQ1MX0.FeUydAJmivwsjPeg0O2WlZkJuHbl28gKG398YxHlkdg"}), users: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.users_path(conn, :show, id))
      assert %{
               "id" => ^id,
               "email" => "test@test.rs",
               "username" => "test",
               "job" => "Employee"
             } = json_response(conn, 200)["data"]
    end
  end

  describe "update users" do
    setup [:create_users]

    test "renders users when data is valid", %{conn: conn, users: %Users{id: id} = users} do
      conn = put(conn, Routes.users_path(conn, :update, users), users: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.users_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "test2@test2.rs",
               "username" => "test2",
               "job" => "Manager"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = put(conn, Routes.users_path(conn, :update, "fakeparam"), users: @invalid_attrs)
      assert response(conn, 400)
    end
  end

  describe "delete users" do
    setup [:create_users]

    test "deletes chosen users", %{conn: conn, users: users} do
      conn = delete(conn, Routes.users_path(conn, :delete, users))
      assert response(conn, 204)
    end
  end

  defp create_users(_) do
    users = users_fixture()
    %{users: users}
  end
end
