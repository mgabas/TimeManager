defmodule Todolist.Schema.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "team" do
    field :members, {:array, :binary_id}, null: false
    field :name, :string, null: false
    field :night_team, :boolean, default: false, null: false
    field :manager, :string, default: "None", null: false

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :members, :night_team, :manager])
    |> validate_required([:name, :members, :night_team, :manager])
  end
end
