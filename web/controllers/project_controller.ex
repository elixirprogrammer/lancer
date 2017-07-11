defmodule Lancer.ProjectController do
  use Lancer.Web, :controller

  def new(conn, _) do
    render conn, :new
  end

end
