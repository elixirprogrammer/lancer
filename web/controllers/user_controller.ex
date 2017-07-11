defmodule Lancer.UserController do
  use Lancer.Web, :controller

  alias Lancer.User

  def index(conn, params) do
    render conn, :index
  end

  def new(conn, _) do
    changeset = User.changeset(%User{})
    render conn, :new, changeset: changeset
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    if conn.assigns.current_user == user do
      changeset = User.changeset(user)
      render(conn, :edit, user: user, changeset: changeset)
    else
      conn
      |> put_flash(:error, "You are not the owner of that user")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.reg_changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} updated successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.reg_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Lancer.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

end
