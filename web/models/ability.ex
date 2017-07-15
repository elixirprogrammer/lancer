defmodule Lancer.Ability do
  use Lancer.Web, :model

  alias Lancer.{Repo, Ability}

  @primary_key false
  schema "abilities" do
    belongs_to :project, Lancer.Project
    belongs_to :skill, Lancer.Skill

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:project_id, :skill_id])
    |> validate_required([:project_id, :skill_id])
  end

  def delete_old_relationship(project, skill) do
    Ability
    |> where(project_id: ^project)
    |> where(skill_id: ^skill)
    |> Repo.delete_all()
  end

  def build_relationship(project, skill) do
    Ability.changeset(%Ability{}, %{project_id: project, skill_id: skill})
    |> Repo.insert()
  end
end
