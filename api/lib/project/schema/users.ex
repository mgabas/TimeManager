defmodule Todolist.Schema.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string, null: false
    field :username, :string, null: false
    field :job, :string, null: false, default: "Employee"
    field :password, :string, null: false
    field :token, :string, null: true

    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:username, :email, :job, :password, :token])
    |> validate_required([:username, :email, :password])
    |> validate_format(:email, ~r/@/)
  end
end
