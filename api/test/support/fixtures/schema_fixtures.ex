defmodule Todolist.SchemaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.Schema` context.
  """

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{
        email: "test@test.rs",
        username: "test",
        job: "Employee",
        password: "pass",
        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6MTYzNjEzNzY1MSwiaWF0IjoxNjM2MTMwNDUxLCJpc3MiOiJKb2tlbiIsImp0aSI6IjJxcWI3dWhmZXMxb3FrZXRubzAwMDIzNSIsIm5iZiI6MTYzNjEzMDQ1MX0.FeUydAJmivwsjPeg0O2WlZkJuHbl28gKG398YxHlkdg"
      })
      |> Todolist.Schema.create_users()

    users
  end

  @doc """
  Generate a clocks.
  """
  def clocks_fixture(attrs \\ %{}) do
    {:ok, clocks} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2021-10-25 08:01:00Z],
        users: "3ad97a32-75d5-401c-892a-e134b410b32c"
      })
      |> Todolist.Schema.create_clocks()

    clocks
  end

  @doc """
  Generate a workingtimes.
  """
  def workingtimes_fixture(attrs \\ %{}) do
    {:ok, workingtimes} =
      attrs
      |> Enum.into(%{
        users: "1df0ce27-4632-41ea-bd74-6c1932ff2185",
        end: ~U[2021-10-25 08:01:00Z],
        start: ~U[2021-10-25 08:01:00Z]
      })
      |> Todolist.Schema.create_workingtimes()

    workingtimes
  end

  @doc """
  Generate a charts.
  """
  def charts_fixture(attrs \\ %{}) do
    {:ok, charts} =
      attrs
      |> Enum.into(%{
        chart1: true,
        chart2: true,
        chart3: true,
        user: "f7d7d9ef-60d8-4c86-8850-1072432b1c0c"
      })
      |> Todolist.Schema.create_charts()

    charts
  end

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        members: ["f7d7d9ef-60d8-4c86-8850-1072432b1c0c", "1df0ce27-4632-41ea-bd74-6c1932ff2185"],
        name: "some name",
        night_team: true,
        manager: "f7d7d9ef-60d8-4c86-8850-1072432b1c0c"
      })
      |> Todolist.Schema.create_team()

    team
  end
end
