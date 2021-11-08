 defmodule TodolistWeb.ChartsControllerTest do
   use TodolistWeb.ConnCase

   import Todolist.SchemaFixtures

   alias Todolist.Schema.Charts

   @create_attrs %{
     chart1: true,
     chart2: true,
     chart3: true,
     user: "3ad97a32-75d5-401c-892a-e134b410b32c"
   }
   @update_attrs %{
     chart1: false,
     chart2: false,
     chart3: false,
     user: "3ad97a32-75d5-401c-892a-e134b410b32c"
   }
   @invalid_attrs %{chart1: nil, chart2: nil, chart3: nil}

   setup %{conn: conn} do
     {:ok, conn: put_req_header(conn, "accept", "application/json")}
   end

   describe "create charts" do
     test "renders charts when data is valid", %{conn: conn} do
       conn = post(conn, Routes.charts_path(conn, :create, "3ad97a32-75d5-401c-892a-e134b410b32c"), charts: @create_attrs)
       assert %{"id" => id} = json_response(conn, 201)["data"]
       conn = get(conn, Routes.charts_path(conn, :show, "3ad97a32-75d5-401c-892a-e134b410b32c"))
       assert %{
                "chart1" => false,
                "chart2" => false,
                "chart3" => false
              } = json_response(conn, 200)["data"]
     end

     test "renders errors when data is invalid", %{conn: conn} do
       conn = post(conn, Routes.charts_path(conn, :create, "fakeparam"), charts: @invalid_attrs)
       assert response(conn, 400)
     end
   end

   defp create_charts(_) do
     charts = charts_fixture()
     %{charts: charts}
   end
 end
