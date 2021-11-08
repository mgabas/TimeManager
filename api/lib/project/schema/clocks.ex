defmodule Todolist.Schema.Clocks do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :utc_datetime, default: DateTime.truncate(DateTime.utc_now, :second), null: false
    field :users, :binary_id, null: false, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(clocks, attrs) do
    clocks
    |> cast(attrs, [:status, :time, :users])
    |> validate_required([:users])
  end
end
