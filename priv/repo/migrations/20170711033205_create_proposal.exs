defmodule Lancer.Repo.Migrations.CreateProposal do
  use Ecto.Migration

  def change do
    create table(:proposals) do
      add :bid, :integer
      add :description, :text
      add :project_id, references(:projects, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:proposals, [:project_id])
    create index(:proposals, [:user_id])

  end
end
