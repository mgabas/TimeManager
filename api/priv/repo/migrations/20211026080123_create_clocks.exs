defmodule Todolist.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :time, :utc_datetime, null: false
      add :status, :boolean, default: false, null: false
      add :users, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:clocks, [:users])
  end
end
