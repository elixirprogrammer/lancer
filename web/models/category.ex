defmodule Lancer.Category do
  use Lancer.Web, :model

  schema "categories" do
    field :name, :string
    has_many :projects, Lancer.Project

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
