defmodule Lancer.UserController do
  use Lancer.Web, :controller

  def index(conn, params) do
    render conn, :index
  end
  
  def new(conn, _) do
    render conn, :new
  end

end
