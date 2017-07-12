defmodule Lancer.Skill do
  use Lancer.Web, :model

  alias Lancer.Skill
  alias Lancer.Ability
  alias Lancer.Repo

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
        skill_changeset = Skill.changeset(%Skill{}, %{name: s})
        skill = find_or_create(skill_changeset)
        changeset = Ability.changeset(%Ability{}, %{project_id: project_id, skill_id: skill.id})
        Repo.insert(changeset)
      end
    end)
  end
end
