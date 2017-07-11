defmodule Lancer.AbilityTest do
  use Lancer.ModelCase

  alias Lancer.Ability

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Ability.changeset(%Ability{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Ability.changeset(%Ability{}, @invalid_attrs)
    refute changeset.valid?
  end
end
