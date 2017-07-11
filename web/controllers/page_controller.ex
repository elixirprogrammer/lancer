defmodule Lancer.PageController do
  use Lancer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
