defmodule Lancer.Repo do
  use Ecto.Repo, otp_app: :lancer
  use Kerosene, per_page: 10
end
