defmodule Lancer.LayoutView do
  use Lancer.Web, :view

  def first_name(%Lancer.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
