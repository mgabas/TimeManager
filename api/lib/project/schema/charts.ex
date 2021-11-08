defmodule Todolist.Schema.Charts do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "charts" do
    field :chart1, :boolean, default: false
    field :chart2, :boolean, default: false
    field :chart3, :boolean, default: false
    field :user, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(charts, attrs) do
    charts
    |> cast(attrs, [:user, :chart1, :chart2, :chart3])
    |> validate_required([:user, :chart1, :chart2, :chart3])
  end
end
