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
end
