defmodule Lancer.UserController do
  use Lancer.Web, :controller

  alias Lancer.User

  def new(conn, _) do
    changeset = User.changeset(%User{})
    render conn, :new, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.reg_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Lancer.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: project_path(conn, :index))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    authenticate_current_user_can(conn, user)
    changeset = User.changeset(user)
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    authenticate_current_user_can(conn, user)
    changeset = User.reg_changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} updated successfully.")
        |> redirect(to: project_path(conn, :index))
      {:error, changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  defp authenticate_current_user_can(conn, user) do
    unless conn.assigns.current_user == user do
      conn
      |> put_flash(:error, "You are not the owner of that user")
      |> redirect(to: project_path(conn, :index))
    end
  end
end
