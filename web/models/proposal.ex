defmodule Lancer.Proposal do
  use Lancer.Web, :model

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
  end
end
