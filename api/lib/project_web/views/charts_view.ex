defmodule TodolistWeb.ChartsView do
  use TodolistWeb, :view
  alias TodolistWeb.ChartsView

  def render("index.json", %{charts: charts}) do
    %{data: render_many(charts, ChartsView, "charts.json")}
  end

  def render("show.json", %{charts: charts}) do
    %{data: render_one(charts, ChartsView, "charts.json")}
  end

  def render("charts.json", %{charts: charts}) do
    %{
      id: charts.id,
      chart1: charts.chart1,
      chart2: charts.chart2,
      chart3: charts.chart3
    }
  end
end
