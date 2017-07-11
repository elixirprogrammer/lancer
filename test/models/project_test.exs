defmodule Lancer.ProjectTest do
  use Lancer.ModelCase

  alias Lancer.Project

  @valid_attrs %{awarded_proposal: 42, budget: 42, description: "some content", latitude: "120.5", location: "some content", longitude: "120.5", name: "some content", open: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end
end
