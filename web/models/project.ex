defmodule Lancer.Project do
  use Lancer.Web, :model

  alias Lancer.{Project, Repo}

  schema "projects" do
    field :name, :string
    field :description, :string
    field :budget, :integer
    field :location, :string
    field :open, :boolean, default: true
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
    |> valid_bid_format(params)
  end

  defp valid_bid_format(changeset, params) do
    message = "Use only numbers please"
    if Map.has_key?(params, "budget") do
      unless Regex.match?(~r/^[0-9]*$/, params["budget"]) do
        changeset = add_error(changeset, :budget, message)
      end
      changeset
    else
      changeset
    end
  end

  def search(params) do
    cond do
      params["q"] == "" ->
        all_paginated(params)

      Map.has_key?(params, "category_id") and params["category_id"] !== "" ->
        category_id = String.to_integer(params["category_id"])
        dynamic = dynamic([p], p.category_id == ^category_id  )
        search_query(params, dynamic)
        |> Repo.paginate(params)

      true ->
        search_query(params, true)
        |> Repo.paginate(params)
    end
  end

  defp search_query(params, dynamic?) do
    dynamic = dynamic([p], ilike(p.name, ^"%#{params["q"]}%") and ^dynamic?)

    from(p in Project,
    order_by: [desc: p.id],
    where: ^dynamic,
    or_where: ilike(p.description, ^"%#{params["q"]}%"),
    preload: [:skills, :category])
  end

  def all_paginated(params) do
    case params["sort-by"] do
      "oldest" ->
        all(params, [asc: :id])
      "name" ->
        all(params, [:name])
      _ ->
        all(params, [desc: :id])
    end
  end

  def manage_all(user) do
    Project
    |> where(user_id: ^user)
    |> order_by([desc: :id])
    |> Repo.all
    |> Repo.preload([:category, :proposals])
  end

  defp all(params, order) do
    Project
    |> order_by(^order)
    |> preload([:skills, :category])
    |> Repo.paginate(params)
  end

end
