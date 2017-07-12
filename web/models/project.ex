defmodule Lancer.Project do
  use Lancer.Web, :model

  schema "projects" do
    field :name, :string
    field :description, :string
    field :budget, :integer
    field :location, :string
    field :open, :boolean, default: false
    field :awarded_proposal, :integer
    belongs_to :user, Lancer.User
    belongs_to :category, Lancer.Category
    has_many :proposals, Lancer.Proposal
    many_to_many :skills, Lancer.Skill, join_through: Lancer.Ability

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :budget, :location, :open, :awarded_proposal, :category_id])
    |> validate_required([:name, :description, :budget, :location, :open, :category_id])
  end

end
