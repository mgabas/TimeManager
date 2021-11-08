defmodule TodolistWeb.TeamView do
  use TodolistWeb, :view
  alias TodolistWeb.TeamView

  def render("index.json", %{team: team}) do
    %{data: render_many(team, TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      members: team.members,
      night_team: team.night_team,
      manager: team.manager
    }
  end
end
