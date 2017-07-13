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

  def search(params) do
    cond do
      params["q"] == "" ->
        all_paginated(params)

      Map.has_key?(params, "category_id") and params["category_id"] !== "" ->
        from(p in Project,
        order_by: [desc: p.id],
        where: [category_id: ^String.to_integer(params["category_id"])],
        where: ilike(p.name, ^"%#{params["q"]}%"),
        or_where: ilike(p.description, ^"%#{params["q"]}%"),
        preload: [:skills, :category])
        |> Repo.paginate(params)

      true ->
        from(p in Project,
        order_by: [desc: p.id],
        where: ilike(p.name, ^"%#{params["q"]}%"),
        or_where: ilike(p.description, ^"%#{params["q"]}%"),
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
