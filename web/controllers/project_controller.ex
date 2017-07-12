defmodule Lancer.ProjectController do
  use Lancer.Web, :controller

  alias Lancer.Project
  alias Lancer.Category
  alias Lancer.Skill

  def new(conn, _) do
    categories = Repo.all(Category)
    changeset = Project.changeset(%Project{})
    render conn, :new, changeset: changeset, categories: categories
  end

  def create(conn, %{"project" => project_params}) do
    categories = Repo.all(Category)
    changeset = Project.changeset(%Project{}, project_params)
    case Repo.insert(changeset) do
      {:ok, project} ->
        Skill.insert_skill_list(project.id, project_params["skills_list"])

        conn
        |> put_flash(:info, "#{project.name} created!")
        |> redirect(to: project_path(conn, :show, project))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset, categories: categories)
    end
  end

end
