defmodule Lancer.Skill do
  use Lancer.Web, :model

  alias Lancer.{Skill, Ability, Repo, Project}

  schema "skills" do
    field :name, :string
    many_to_many :projects, Lancer.Project, join_through: Lancer.Ability

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
  end

  def find_or_create(skill) do
    query = from s in Skill,
            where: s.name == ^skill.changes.name
    Repo.one(query) || Repo.insert!(skill)
  end

  def insert_skill_list(project_id, skills_list) do
    skills = skills_list |> String.split(",") |> Enum.uniq()
    Enum.each(skills, fn(s) ->
      unless s == "" do
        build_relationship(s, project_id)
      end
    end)
  end

  def update_skill_list(project, skills_list) do
    skills = skills_list |> String.split(",") |> Enum.uniq()
    old_skills = Project.get_skills(project) |> String.split(",") |> Enum.uniq()
    # Delete old skill if not found in new list and not empty
    unless old_skills == [""] do
      Enum.each(old_skills, fn(old_s) ->
        unless Enum.find_value(skills, fn(s) -> s == old_s end) do
          delete_relationship(old_s, project.id)
        end
      end)
    end
    # Insert new skill if not found in the old list and not empty
    unless skills == [""] do
      Enum.each(skills, fn(s) ->
        unless Enum.find_value(old_skills, fn(old_s) -> old_s == s end) do
          build_relationship(s, project.id)
        end
      end)
    end
  end

  defp build_relationship(s, project_id) do
    skill_changeset = Skill.changeset(%Skill{}, %{name: s})
    skill = find_or_create(skill_changeset)
    Ability.build_relationship(project_id, skill.id)
  end

  defp delete_relationship(old_s, project_id) do
    skill_changeset = Skill.changeset(%Skill{}, %{name: old_s})
    skill = find_or_create(skill_changeset)
    Ability.delete_old_relationship(project_id, skill.id)
  end
end
