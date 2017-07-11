defmodule Lancer.PageController do
  use Lancer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def about(conn, _params) do
    conn
    |> put_layout(false)
    |> render :about
  end

  def contact(conn, _params) do
    render conn, :contact
  end

  def faq(conn, _params) do
    render conn, :faq
  end
end
