defmodule TodolistWeb.UsersController do
  use TodolistWeb, :controller

  require Logger
  require UUID
  require Todolist.JwtAuthToken
  alias Todolist.Schema
  alias Todolist.Schema.Users

  action_fallback TodolistWeb.FallbackController

  def index(conn, params) do
    users = if Map.has_key?(params, "username") &&
                 Map.has_key?(params, "email") &&
                 params |> map_size == 2 do
                if byte_size(params["username"]) <= 0 ||
                 byte_size(params["email"]) <= 0 do
                  conn |> put_status(400) |> send_resp(400, "Bad request, username or email can't be null")
                  end
      username = params["username"]
      email = params["email"]
      users = Schema.get_users_by_username_email(username, email)
                if users === nil do
                  conn |> put_status(400) |> send_resp(400, "Bad request, unknown username/email pair")
                  end
      [users]
    else
      Schema.list_users()
    end
    render(conn, "index.json", users: users)
  end

  def getTeamMembersByTeamId(conn, %{"id" => id}) do
    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    else
      Logger.debug "Here is id : #{inspect(id)}"
      team = Schema.get_team(id)
      if team === nil do
        conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
      else
        res = team.members
              |> Enum.map(fn(member) -> Logger.debug "In da map: #{inspect(member)}"; Schema.get_users(member) end)
        Logger.debug "Here is res: #{inspect(res)}"
        render(conn, "index.json", users: res)
      end
    end
  end

  def create(conn, %{"users" => users_params}) do
    check_exist = Schema.get_user_by_email(users_params["email"])
    if (check_exist !== nil) do
      conn |> put_status(400) |> send_resp(400, "Bad request, this email is already used")
    else
      with {:ok, %Users{} = users} <- Schema.create_users(%{"password" => users_params["password"], "email" => users_params["email"],
        "username" => users_params["username"], "job" => users_params["job"]}) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.users_path(conn, :show, users))
        |> render("show.json", users: users)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    else
      users = Schema.get_users(id)
      if users === nil do
        conn |> put_status(400) |> send_resp(400, "Bad Request, unknown user")
      end
      render(conn, "show.json", users: users)
    end
  end

  def getUserByToken(conn, %{"token" => token}) do
    if Todolist.JwtAuthToken.verifyToken(token) === False do
      conn |> put_status(400) |> send_resp(401, "Unauthorized, wrong token")
    else
      users = Schema.get_user_by_token(token)
      if users === nil do
        conn |> put_status(400) |> send_resp(400, "Bad Request, unknown user")
      else
        render(conn, "show.json", users: users)
      end
    end
  end

  def update(conn, %{"id" => id, "users" => users_params}) do
    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    else
    users = Schema.get_users(id)
    if users === nil do
      conn |> put_status(400) |> send_resp(400, "Bad request, unknown UUID")
    end
      with {:ok, %Users{} = users} <- Schema.update_users(users, users_params) do
        render(conn, "show.json", users: users)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    if UUID.info(id) === {:error, "Invalid argument; Not a valid UUID: #{id}"} do
      conn |> put_status(400) |> send_resp(400, "Bad request, the given parameter is not UUID format")
    end

    users = Schema.get_users(id)
    if users === nil do
      conn |> put_status(400) |> send_resp(400, "Bad request, unknown UUID")
    end

    deleted_users = %{"username" => id,
                      "email" => "#{id}@uu.id"}
    with {:ok, %Users{}} <- Schema.update_users(users, deleted_users) do
      send_resp(conn, :no_content, "")
    end
  end

  def signInUser(conn, %{"users" => users_params}) do
    user = Schema.get_user_by_email(users_params["email"])
    if (user === nil) do
      conn |> put_status(400) |> send_resp(404, "Not Found, unknown user")
    else
      if (users_params["password"] === user.password) do
        token = createToken(users_params)
        Schema.update_users(user, %{"token" => Enum.at(Tuple.to_list(token["token"]), 1)})
        Logger.debug "Here is result : #{inspect(Enum.at(Tuple.to_list(token["token"]), 1))} ///////////// #{inspect(%{:id => user.id, :password => users_params["password"], :email => users_params["email"],
          :username => users_params["username"], :job => users_params["job"],
          :token => token})}"
        render(conn, "show.json", users: %{:id => user.id, :password => users_params["password"], :email => users_params["email"],
          :username => user.username, :job => user.job,
          :token => Enum.at(Tuple.to_list(token["token"]), 1)})
      else
        conn |> put_status(401) |> send_resp(401, "Unauthorized, wrong email/password")
      end
      conn |> put_status(404) |> send_resp(404, "Not Found, unknown user")
    end
  end

  def logoutUser(conn, %{"users" => users_params}) do
    user = Schema.get_user_by_email(users_params["email"])
    if (user === nil) do
      conn |> put_status(400) |> send_resp(404, "Not found, unknown user")
    else
    Logger.debug "HERE"
      if user.token === nil do
        conn |> put_status(400) |> send_resp(400, "Bad Request, user is already logout")
      else
        Schema.update_users(user, %{"token" => nil})
        render(conn, "show.json", users: user)
      end
    end
  end

  def createToken(users_params) do
    extra_claims = %{"username" => users_params["username"], "email" => users_params["email"],
      "password" => users_params["password"], "job" => users_params["job"]}
    token = Todolist.JwtAuthToken.generate_and_sign()
    %{"password" => users_params["password"], "email" => users_params["email"],
      "username" => users_params["username"], "job" => users_params["job"], "token" => token}
  end

end
