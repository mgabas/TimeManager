defmodule Todolist.Repo.Migrations.CreateTeam do
  use Ecto.Migration

  def change do
    create table(:team, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :members, {:array, :binary_id}, null: false
      add :night_team, :boolean, default: false, null: false
      add :manager, :string, default: "None", null: false

      timestamps()
    end
  end
end
