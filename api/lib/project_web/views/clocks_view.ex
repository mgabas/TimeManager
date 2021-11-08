defmodule TodolistWeb.ClocksView do
  use TodolistWeb, :view
  alias TodolistWeb.ClocksView

  def render("index.json", %{clocks: clocks}) do
    %{data: render_many(clocks, ClocksView, "clocks.json")}
  end

  def render("show.json", %{clocks: clocks}) do
    %{data: render_one(clocks, ClocksView, "clocks.json")}
  end

  def render("clocks.json", %{clocks: clocks}) do
    %{
      id: clocks.id,
      time: clocks.time,
      status: clocks.status,
      users: clocks.users
    }
  end
end
