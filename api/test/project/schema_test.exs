defmodule Todolist.SchemaTest do
  use Todolist.DataCase
  require Logger

  alias Todolist.Schema

  describe "users" do
    alias Todolist.Schema.Users

    import Todolist.SchemaFixtures

    @invalid_attrs %{email: nil, username: nil, job: nil}

    test "list_users/0 returns all users" do
      users = users_fixture()
      Logger.debug "Here is the first #{inspect(Schema.list_users())} and also second : #{inspect([users])}"
      assert Schema.list_users() != nil
    end

    test "get_users!/1 returns the users with given id" do
      users = users_fixture()
      assert Schema.get_users!(users.id) == users
    end

    test "create_users/1 with valid data creates a users" do
      valid_attrs = %{email: "test@test.rs", username: "test", job: "Administrator", password: "pass", token: nil}

      assert {:ok, %Users{} = users} = Schema.create_users(valid_attrs)
      assert users.email == "test@test.rs"
      assert users.username == "test"
      assert users.job == "Administrator"
    end

    test "create_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_users(@invalid_attrs)
    end

    test "update_users/2 with valid data updates the users" do
      users = users_fixture()
      update_attrs = %{email: "test2@test2.rs", username: "test2", job: "Employee"}

      assert {:ok, %Users{} = users} = Schema.update_users(users, update_attrs)
      assert users.email == "test2@test2.rs"
      assert users.username == "test2"
      assert users.job == "Employee"
    end

    test "update_users/2 with invalid data returns error changeset" do
      users = users_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_users(users, @invalid_attrs)
      assert users == Schema.get_users!(users.id)
    end

    test "delete_users/1 deletes the users" do
      users = users_fixture()
      assert {:ok, %Users{}} = Schema.delete_users(users)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_users!(users.id) end
    end

    test "change_users/1 returns a users changeset" do
      users = users_fixture()
      assert %Ecto.Changeset{} = Schema.change_users(users)
    end
  end

  describe "clocks" do
    alias Todolist.Schema.Clocks

    import Todolist.SchemaFixtures

    @invalid_attrs %{status: nil, time: nil, users: nil}

    test "list_clocks/0 returns all clocks" do
      clocks = clocks_fixture()
      assert Schema.list_clocks() != nil
    end

    test "get_clocks!/1 returns the clocks with given id" do
      clocks = clocks_fixture()
      assert Schema.get_clocks!(clocks.id) == clocks
    end

    test "create_clocks/1 with valid data creates a clocks" do
      valid_attrs = %{status: true, time: ~U[2021-10-26 08:01:00Z], users: "3ad97a32-75d5-401c-892a-e134b410b32c"}

      assert {:ok, %Clocks{} = clocks} = Schema.create_clocks(valid_attrs)
      assert clocks.status == true
      assert clocks.time == ~U[2021-10-26 08:01:00Z]
      assert clocks.users == "3ad97a32-75d5-401c-892a-e134b410b32c"
    end

    test "create_clocks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_clocks(@invalid_attrs)
    end

    test "update_clocks/2 with valid data updates the clocks" do
      clocks = clocks_fixture()
      update_attrs = %{status: false, time: ~U[2021-10-26 08:01:00Z], users: "3ad97a32-75d5-401c-892a-e134b410b32c"}

      assert {:ok, %Clocks{} = clocks} = Schema.update_clocks(clocks, update_attrs)
      assert clocks.status == false
      assert clocks.time == ~U[2021-10-26 08:01:00Z]
      assert clocks.users == "3ad97a32-75d5-401c-892a-e134b410b32c"
    end

    test "update_clocks/2 with invalid data returns error changeset" do
      clocks = clocks_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_clocks(clocks, @invalid_attrs)
      assert clocks == Schema.get_clocks!(clocks.id)
    end

    test "delete_clocks/1 deletes the clocks" do
      clocks = clocks_fixture()
      assert {:ok, %Clocks{}} = Schema.delete_clocks(clocks)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_clocks!(clocks.id) end
    end

    test "change_clocks/1 returns a clocks changeset" do
      clocks = clocks_fixture()
      assert %Ecto.Changeset{} = Schema.change_clocks(clocks)
    end
  end

  describe "workingtimes" do
    alias Todolist.Schema.Workingtimes

    import Todolist.SchemaFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      workingtimes = workingtimes_fixture()
      assert Schema.list_workingtimes() != nil
    end

    test "get_workingtimes!/1 returns the workingtimes with given id" do
      workingtimes = workingtimes_fixture()
      assert Schema.get_workingtimes!(workingtimes.id) == workingtimes
    end

    test "create_workingtimes/1 with valid data creates a workingtimes" do
      valid_attrs = %{end: ~U[2021-10-25 08:01:00Z], start: ~U[2021-10-25 08:01:00Z], users: "3ad97a32-75d5-401c-892a-e134b410b32c"}

      assert {:ok, %Workingtimes{} = workingtimes} = Schema.create_workingtimes(valid_attrs)
      assert workingtimes.end == ~U[2021-10-25 08:01:00Z]
      assert workingtimes.start == ~U[2021-10-25 08:01:00Z]
      assert workingtimes.users == "3ad97a32-75d5-401c-892a-e134b410b32c"
    end

    test "create_workingtimes/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_workingtimes(@invalid_attrs)
    end

    test "update_workingtimes/2 with valid data updates the workingtimes" do
      workingtimes = workingtimes_fixture()
      update_attrs = %{end: ~U[2021-10-26 08:01:00Z], start: ~U[2021-10-26 08:01:00Z], users: "3ad97a32-75d5-401c-892a-e134b410b32c"}

      assert {:ok, %Workingtimes{} = workingtimes} = Schema.update_workingtimes(workingtimes, update_attrs)
      assert workingtimes.end == ~U[2021-10-26 08:01:00Z]
      assert workingtimes.start == ~U[2021-10-26 08:01:00Z]
      assert workingtimes.users == "3ad97a32-75d5-401c-892a-e134b410b32c"
    end

    test "update_workingtimes/2 with invalid data returns error changeset" do
      workingtimes = workingtimes_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_workingtimes(workingtimes, @invalid_attrs)
      assert workingtimes == Schema.get_workingtimes!(workingtimes.id)
    end

    test "delete_workingtimes/1 deletes the workingtimes" do
      workingtimes = workingtimes_fixture()
      assert {:ok, %Workingtimes{}} = Schema.delete_workingtimes(workingtimes)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_workingtimes!(workingtimes.id) end
    end

    test "change_workingtimes/1 returns a workingtimes changeset" do
      workingtimes = workingtimes_fixture()
      assert %Ecto.Changeset{} = Schema.change_workingtimes(workingtimes)
    end
  end

  # describe "charts" do
  #   alias Todolist.Schema.Charts

  #   import Todolist.SchemaFixtures

  #   @invalid_attrs %{chart1: nil, chart2: nil, chart3: nil, user: nil}

  #   test "list_charts/0 returns all charts" do
  #     charts = charts_fixture()
  #     assert Schema.list_charts() == [charts]
  #   end

  #   test "get_charts!/1 returns the charts with given id" do
  #     charts = charts_fixture()
  #     assert Schema.get_charts!(charts.id) == charts
  #   end

  #   test "create_charts/1 with valid data creates a charts" do
  #     valid_attrs = %{chart1: true, chart2: true, chart3: true, user: "f7d7d9ef-60d8-4c86-8850-1072432b1c0c"}

  #     assert {:ok, %Charts{} = charts} = Schema.create_charts(valid_attrs)
  #     assert charts.chart1 == true
  #     assert charts.chart2 == true
  #     assert charts.chart3 == true
  #     assert charts.user == "f7d7d9ef-60d8-4c86-8850-1072432b1c0c"
  #   end

  #   test "create_charts/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Schema.create_charts(@invalid_attrs)
  #   end

  #   test "update_charts/2 with valid data updates the charts" do
  #     charts = charts_fixture()
  #     update_attrs = %{chart1: false, chart2: false, chart3: false, user: "7488a646-e31f-11e4-aace-600308960668"}

  #     assert {:ok, %Charts{} = charts} = Schema.update_charts(charts, update_attrs)
  #     assert charts.chart1 == false
  #     assert charts.chart2 == false
  #     assert charts.chart3 == false
  #     assert charts.user == "7488a646-e31f-11e4-aace-600308960668"
  #   end

  #   test "update_charts/2 with invalid data returns error changeset" do
  #     charts = charts_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Schema.update_charts(charts, @invalid_attrs)
  #     assert charts == Schema.get_charts!(charts.id)
  #   end

  #   test "delete_charts/1 deletes the charts" do
  #     charts = charts_fixture()
  #     assert {:ok, %Charts{}} = Schema.delete_charts(charts)
  #     assert_raise Ecto.NoResultsError, fn -> Schema.get_charts!(charts.id) end
  #   end

  #   test "change_charts/1 returns a charts changeset" do
  #     charts = charts_fixture()
  #     assert %Ecto.Changeset{} = Schema.change_charts(charts)
  #   end
  # end

  describe "team" do
    alias Todolist.Schema.Team

    import Todolist.SchemaFixtures

    @invalid_attrs %{members: nil, name: nil, night_team: nil}

    test "list_team/0 returns all team" do
      team = team_fixture()
      assert Schema.list_team() != nil
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Schema.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{members: ["f7d7d9ef-60d8-4c86-8850-1072432b1c0c", "1df0ce27-4632-41ea-bd74-6c1932ff2185"], name: "some name", night_team: true}

      assert {:ok, %Team{} = team} = Schema.create_team(valid_attrs)
      assert team.members == ["f7d7d9ef-60d8-4c86-8850-1072432b1c0c", "1df0ce27-4632-41ea-bd74-6c1932ff2185"]
      assert team.name == "some name"
      assert team.night_team == true
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{members: ["f7d7d9ef-60d8-4c86-8850-1072432b1c0c", "1df0ce27-4632-41ea-bd74-6c1932ff2185"], name: "some updated name", night_team: false}

      assert {:ok, %Team{} = team} = Schema.update_team(team, update_attrs)
      assert team.members == ["f7d7d9ef-60d8-4c86-8850-1072432b1c0c", "1df0ce27-4632-41ea-bd74-6c1932ff2185"]
      assert team.name == "some updated name"
      assert team.night_team == false
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_team(team, @invalid_attrs)
      assert team == Schema.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Schema.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Schema.change_team(team)
    end
  end
end
