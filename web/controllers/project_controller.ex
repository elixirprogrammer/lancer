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

  def manage_projects(conn, _params) do
    projects = Project.manage_all(conn.assigns.current_user.id)

    render(conn, :manage_projects, projects: projects)
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

  def edit(conn, %{"id" => id}) do
    categories = Repo.all(Category)
    project = Repo.get!(Project, id) |> Repo.preload([:skills, :user])
    user_owns_project?(conn, project.user)
    changeset = Project.changeset(project)
    render conn, :edit, changeset: changeset, categories: categories, project: project
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    categories = Repo.all(Category)
    project = Repo.get!(Project, id) |> Repo.preload([:skills, :user])
    user_owns_project?(conn, project.user)
    changeset = Project.changeset(project, project_params)

    case Repo.update(changeset) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "#{project.name} updated successfully.")
        |> redirect(to: project_path(conn, :show, project))
      {:error, changeset} ->
        render conn, :edit, changeset: changeset, categories: categories, project: project
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Repo.get!(Project, id) |> Repo.preload(:user)
    user_owns_project?(conn, project.user)
    Repo.delete!(project)

    conn
    |> put_flash(:info, "Project #{project.name} deleted successfully.")
    |> redirect(to: project_path(conn, :manage_projects))
  end

  def show(conn, %{"id" => id}) do
    proposal_changeset = Proposal.changeset(%Proposal{})
    changeset = Project.changeset(%Project{})
    project = Repo.get!(Project, id) |> Repo.preload([{:proposals, :user}])
    awarded_proposal = Proposal.awarded_proposal?(project.awarded_proposal)
    skills = Repo.all assoc(project, :skills)

    render(conn, :show,
      project: project,
      skills: skills,
      changeset: changeset,
      proposal_changeset: proposal_changeset,
      awarded_proposal: awarded_proposal)
  end

  def award_proposal(conn, %{"id" => id, "project" => project_params}) do
    project = Repo.get!(Project, id) |> Repo.preload(:user)
    user_owns_project?(conn, project.user)
    changeset = Project.changeset(project, project_params)

    Repo.update!(changeset)
    conn
    |> redirect(to: project_path(conn, :show, project))
  end

  defp user_owns_project?(conn, project_user) do
    unless project_user == conn.assigns.current_user do
      conn
      |> put_flash(:error, "You are not the owner of that project.")
      |> redirect(to: project_path(conn, :index))
    end
  end

end
