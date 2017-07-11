defmodule Lancer.Repo.Migrations.CreateAbility do
  use Ecto.Migration

  def change do
    create table(:abilities, primary_key: false) do
      add :project_id, references(:projects)
      add :skill_id, references(:skills)

      timestamps()
    end
    create index(:abilities, [:project_id])
    create index(:abilities, [:skill_id])

  end
end
