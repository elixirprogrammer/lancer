defmodule Lancer.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :description, :text
      add :budget, :integer
      add :location, :string
      add :open, :boolean, default: true, null: false
      add :awarded_proposal, :integer
      add :user_id, references(:users, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)

      timestamps()
    end
    create index(:projects, [:user_id])
    create index(:projects, [:category_id])

  end
end
