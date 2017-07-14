defmodule Lancer.ProposalController do
  use Lancer.Web, :controller

  alias Lancer.{Repo, Proposal, Project}

  def create(conn, params) do
    project = Repo.get!(Project, params["project_id"])
    can_user_bid_project?(conn, project.id)
    skills = Repo.all assoc(project, :skills)
    changeset = Proposal.changeset(%Proposal{
      user_id: conn.assigns.current_user.id,
      project_id: String.to_integer(params["project_id"])}, params["proposal"])

    case Repo.insert(changeset) do
      {:ok, proposal} ->
        conn
        |> put_flash(:info, "Proposal created!")
        |> redirect(to: project_path(conn, :show, project))
      {:error, changeset} ->
        render(conn, Lancer.ProjectView, :show, project: project, skills: skills, changeset: changeset)
    end
  end

  defp can_user_bid_project?(conn, project_id) do
    unless Proposal.can_user_bid_project?(project_id, conn.assigns.current_user.id) do
      conn
      |> put_flash(:error, "You already bid on this job!")
      |> redirect(to: project_path(conn, :index))
    end
  end
end
