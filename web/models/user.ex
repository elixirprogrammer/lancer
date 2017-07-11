defmodule Lancer.User do
  use Lancer.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :username, :string
    field :password_hash, :string
    has_many :projects, Lancer.Project
    has_many :proposals, Lancer.Proposal

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :username, :password_hash])
    |> validate_required([:name, :email, :username, :password_hash])
  end
end
