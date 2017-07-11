defmodule Lancer.Ability do
  use Lancer.Web, :model

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
end
