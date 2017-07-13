defmodule Lancer.ProjectController do
  use Lancer.Web, :controller

  alias Lancer.{Project, Category, Skill, Proposal}

  def index(conn, params) do
    categories = Repo.all(Category)
    users_count = Lancer.User |> Lancer.Repo.all |> length()
    {projects, kerosene} = Project.all_paginated(params)

    render(conn, :index,
      projects: projects,
      kerosene: kerosene,
      users_count: users_count,
      categories: categories)
  end

  def search(conn, params) do
    categories = Repo.all(Category)
    users_count = Lancer.User |> Lancer.Repo.all |> length()
    {projects, kerosene} = Project.search(params)

    render(conn, :search,
      projects: projects,
      kerosene: kerosene,
      users_count: users_count,
      categories: categories)
  end

  def new(conn, _) do
    categories = Repo.all(Category)
    changeset = Project.changeset(%Project{})
    render conn, :new, changeset: changeset, categories: categories
  end

  def create(conn, %{"project" => project_params}) do
    categories = Repo.all(Category)
    changeset = Project.changeset(%Project{user_id: conn.assigns.current_user.id}, project_params)
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

  def show(conn, %{"id" => id}) do
    changeset = Proposal.changeset(%Proposal{})
    project = Repo.get!(Project, id)
    skills = Repo.all assoc(project, :skills)
    render(conn, :show, project: project, skills: skills, changeset: changeset)
  end

end
