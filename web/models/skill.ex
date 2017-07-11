defmodule Lancer.Skill do
  use Lancer.Web, :model

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
    |> validate_required([:name])
  end
end
