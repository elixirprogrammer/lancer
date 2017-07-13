defmodule Lancer.Project do
  use Lancer.Web, :model

  alias Lancer.{Project, Repo}

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

  def search(q_param, params) do
    if q_param == "" do
      all_paginated(params)
    else
      from(p in Project,
      order_by: [desc: p.id],
      where: ilike(p.name, ^"%#{q_param}%"),
      or_where: ilike(p.description, ^"%#{q_param}%"),
      preload: [:skills, :category])
      |> Repo.paginate(params)
    end
  end

  def all_paginated(params) do
    Project
    |> order_by(desc: :id)
    |> preload([:skills, :category])
    |> Repo.paginate(params)
  end

end
