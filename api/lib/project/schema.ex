defmodule Todolist.Schema do
  @moduledoc """
  The Schema context.
  """

  import Ecto.Query, warn: false
  alias Todolist.Repo
  require Logger

  alias Todolist.Schema.Users

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%Users{}, ...]

  """
  def list_users do
    Repo.all(Users)
  end

  @doc """
  Gets a single users.

  Raises `Ecto.NoResultsError` if the Users does not exist.

  ## Examples

      iex> get_users!(123)
      %Users{}

      iex> get_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_users!(id), do: Repo.get!(Users, id)
  def get_users(id), do: Repo.get(Users, id)

  def get_user_by_username(username), do: Repo.get_by(Users, [username: username])

  def get_user_by_email(email), do: Repo.get_by(Users, [email: email])

  def get_users_by_username_email!(username_sent, email_sent), do: Repo.get_by!(Users, [username: username_sent, email: email_sent])
  def get_users_by_username_email(username_sent, email_sent), do: Repo.get_by(Users, [username: username_sent, email: email_sent])

  def get_user_by_token(token), do: Repo.get_by(Users, token: token)

  @doc """
  Creates a users.

  ## Examples

      iex> create_users(%{field: value})
      {:ok, %Users{}}

      iex> create_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_users(attrs \\ %{}) do
    %Users{}
    |> Users.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a users.

  ## Examples

      iex> update_users(users, %{field: new_value})
      {:ok, %Users{}}

      iex> update_users(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_users(%Users{} = users, attrs) do
    users
    |> Users.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a users.

  ## Examples

      iex> delete_users(users)
      {:ok, %Users{}}

      iex> delete_users(users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_users(%Users{} = users) do
    Repo.delete(users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking users changes.

  ## Examples

      iex> change_users(users)
      %Ecto.Changeset{data: %Users{}}

  """
  def change_users(%Users{} = users, attrs \\ %{}) do
    Users.changeset(users, attrs)
  end

  alias Todolist.Schema.Clocks

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clocks{}, ...]

  """
  def list_clocks do
    Repo.all(Clocks)
  end

  @doc """
  Gets a single clocks.

  Raises `Ecto.NoResultsError` if the Clocks does not exist.

  ## Examples

      iex> get_clocks!(123)
      %Clocks{}

      iex> get_clocks!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clocks!(id), do: Repo.get!(Clocks, id)
  def get_clocks(id), do: Repo.get(Clocks, id)

  def get_clocks_by_userid!(users_sent), do: Repo.get_by!(Clocks, [users: users_sent])
  def get_clocks_by_userid(users_sent), do: Repo.get_by(Clocks, [users: users_sent])


  @doc """
  Creates a clocks.

  ## Examples

      iex> create_clocks(%{field: value})
      {:ok, %Clocks{}}

      iex> create_clocks(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clocks(attrs \\ %{}) do
    %Clocks{}
    |> Clocks.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clocks.

  ## Examples

      iex> update_clocks(clocks, %{field: new_value})
      {:ok, %Clocks{}}

      iex> update_clocks(clocks, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clocks(%Clocks{} = clocks, attrs) do
    clocks
    |> Clocks.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clocks.

  ## Examples

      iex> delete_clocks(clocks)
      {:ok, %Clocks{}}

      iex> delete_clocks(clocks)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clocks(%Clocks{} = clocks) do
    Repo.delete(clocks)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clocks changes.

  ## Examples

      iex> change_clocks(clocks)
      %Ecto.Changeset{data: %Clocks{}}

  """
  def change_clocks(%Clocks{} = clocks, attrs \\ %{}) do
    Clocks.changeset(clocks, attrs)
  end

  alias Todolist.Schema.Workingtimes

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%Workingtimes{}, ...]

  """
  def list_workingtimes do
    Repo.all(Workingtimes)
  end

  @doc """
  Gets a single workingtimes.

  Raises `Ecto.NoResultsError` if the Workingtimes does not exist.

  ## Examples

      iex> get_workingtimes!(123)
      %Workingtimes{}

      iex> get_workingtimes!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workingtimes!(id), do: Repo.get!(Workingtimes, id)
  def get_workingtimes(id), do: Repo.get(Workingtimes, id)

  def get_workingtimes_by_userid(user_sent) do
    query = from working_times in Workingtimes, where: working_times.users==^user_sent, select: working_times
    Repo.all(query)
  end

  def get_workingtimes_by_work_id(id), do: Repo.get_by(Workingtimes, [id: id])
  def get_all_working_times(), do: Repo.all(Workingtimes)

  def get_workingtimes_by_start_end!(users_sent, start_sent, end_sent), do: Repo.get_by!(Workingtimes, [users: users_sent, start: start_sent, end: end_sent])
  def get_workingtimes_by_start_end(users_sent, start_sent, end_sent), do: Repo.get_by(Workingtimes, [users: users_sent, start: start_sent, end: end_sent])

  @doc """
  Creates a workingtimes.

  ## Examples

      iex> create_workingtimes(%{field: value})
      {:ok, %Workingtimes{}}

      iex> create_workingtimes(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workingtimes(attrs) do
    %Workingtimes{}
    |> Workingtimes.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workingtimes.

  ## Examples

      iex> update_workingtimes(workingtimes, %{field: new_value})
      {:ok, %Workingtimes{}}

      iex> update_workingtimes(workingtimes, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workingtimes(%Workingtimes{} = workingtimes, attrs) do
    workingtimes
    |> Workingtimes.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workingtimes.

  ## Examples

      iex> delete_workingtimes(workingtimes)
      {:ok, %Workingtimes{}}

      iex> delete_workingtimes(workingtimes)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workingtimes(%Workingtimes{} = workingtimes) do
    Repo.delete(workingtimes)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtimes changes.

  ## Examples

      iex> change_workingtimes(workingtimes)
      %Ecto.Changeset{data: %Workingtimes{}}

  """
  def change_workingtimes(%Workingtimes{} = workingtimes, attrs \\ %{}) do
    Workingtimes.changeset(workingtimes, attrs)
  end

  alias Todolist.Schema.Charts

  @doc """
  Returns the list of charts.

  ## Examples

      iex> list_charts()
      [%Charts{}, ...]

  """
  def list_charts do
    Repo.all(Charts)
  end

  @doc """
  Gets a single charts.

  Raises `Ecto.NoResultsError` if the Charts does not exist.

  ## Examples

      iex> get_charts!(123)
      %Charts{}

      iex> get_charts!(456)
      ** (Ecto.NoResultsError)

  """
  def get_charts!(id), do: Repo.get!(Charts, id)
  def get_charts_by_user_id(id), do: Repo.get_by(Charts, user: id)

  @doc """
  Creates a charts.

  ## Examples

      iex> create_charts(%{field: value})
      {:ok, %Charts{}}

      iex> create_charts(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_charts(attrs \\ %{}) do
    %Charts{}
    |> Charts.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a charts.

  ## Examples

      iex> update_charts(charts, %{field: new_value})
      {:ok, %Charts{}}

      iex> update_charts(charts, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_charts(%Charts{} = charts, attrs) do
    charts
    |> Charts.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a charts.

  ## Examples

      iex> delete_charts(charts)
      {:ok, %Charts{}}

      iex> delete_charts(charts)
      {:error, %Ecto.Changeset{}}

  """
  def delete_charts(%Charts{} = charts) do
    Repo.delete(charts)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking charts changes.

  ## Examples

      iex> change_charts(charts)
      %Ecto.Changeset{data: %Charts{}}

  """
  def change_charts(%Charts{} = charts, attrs \\ %{}) do
    Charts.changeset(charts, attrs)
  end

  alias Todolist.Schema.Team

  @doc """
  Returns the list of team.

  ## Examples

      iex> list_team()
      [%Team{}, ...]

  """
  def list_team do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)
  def get_team(id), do: Repo.get(Team, id)

  def get_all_team(), do: Repo.all(Team)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end
end
