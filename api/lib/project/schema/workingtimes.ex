defmodule Todolist.Schema.Workingtimes do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "workingtimes" do
    field :end, :utc_datetime, default: DateTime.truncate(DateTime.utc_now, :second), null: false
    field :start, :utc_datetime, default: DateTime.truncate(DateTime.utc_now, :second), null: false
    field :users, :binary_id, null: false

    timestamps()
  end

  @doc false
  def changeset(workingtimes, attrs) do
    workingtimes
    |> cast(attrs, [:start, :end, :users])
    |> validate_required([:start, :end, :users])
  end
end
