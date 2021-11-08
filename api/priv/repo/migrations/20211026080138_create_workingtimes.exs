defmodule Todolist.Repo.Migrations.CreateWorkingtimes do
  use Ecto.Migration

  def change do
    create table(:workingtimes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :utc_datetime, null: false
      add :end, :utc_datetime, null: false
      add :users, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:workingtimes, [:users])
  end
end
