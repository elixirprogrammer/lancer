defmodule Lancer.Proposal do
  use Lancer.Web, :model

  alias Lancer.{Proposal, Repo}

  schema "proposals" do
    field :bid, :integer
    field :description, :string
    belongs_to :project, Lancer.Project
    belongs_to :user, Lancer.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:bid, :description])
    |> validate_required([:bid, :description])
    |> valid_bid_format(params)
  end

  defp valid_bid_format(changeset, params) do
    message = "Use only numbers please"
    if Map.has_key?(params, "bid") do
      unless Regex.match?(~r/^[0-9]*$/, params["bid"]) do
        changeset = add_error(changeset, :bid, message)
      end
      changeset
    else
      changeset
    end
  end

  def can_user_bid_project?(project_id, user_id) do
    query =
    Proposal
    |> where(user_id: ^user_id)
    |> where(project_id: ^project_id)
    |> limit(1)
    |> Repo.all()

    able? = if query == [], do: true, else: false
  end

  def awarded_proposal?(proposal) do
    List.first query =
      Proposal
      |> where(id: ^proposal)
      |> limit(1)
      |> Repo.all()
      |> Repo.preload(:user)
  end
end
