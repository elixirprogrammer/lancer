# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Lancer.Repo.insert!(%Lancer.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Lancer.{Repo, User, Project, Category, Ability, Skill, Proposal}

Repo.delete_all User
(1..10) |> Enum.each(fn n ->
  User.reg_changeset(%User{}, %{
                        name: Faker.Name.title,
                        email: Faker.Internet.free_email,
                        username: Faker.Internet.user_name,
                        password: "password123",
                        password_confirmation: "password123"})
  |> Repo.insert!()
end)

Repo.delete_all Category
Category.changeset(%Category{}, %{name: "Web Development"})
|> Repo.insert!()

Category.changeset(%Category{}, %{name: "Design"})
|> Repo.insert!()

Category.changeset(%Category{}, %{name: "Finance"})
|> Repo.insert!()

Category.changeset(%Category{}, %{name: "Engineering"})
|> Repo.insert!()

Category.changeset(%Category{}, %{name: "Sales"})
|> Repo.insert!()

Category.changeset(%Category{}, %{name: "Administrative"})
|> Repo.insert!()

Repo.delete_all Project
(1..50) |> Enum.each(fn n ->
  Project.changeset(%Project{}, %{
                        name: Faker.Name.title ,
                        description: Faker.Lorem.paragraph(%Range{first: 1, last: 40}),
                        budget: Enum.random(1000..20000),
                        location: "#{Faker.Address.city}, #{Faker.Address.state_abbr}",
                        user_id: :rand.uniform(10),
                        category_id: :rand.uniform(6)})
  |> Repo.insert!()
end)

Repo.delete_all Skill
(1..100) |> Enum.each(fn n ->
  Skill.changeset(%Skill{}, %{name: Faker.Superhero.power})
  |> Repo.insert!()
end)

Repo.delete_all Ability
(1..200) |> Enum.each(fn n ->
  Ability.changeset(%Ability{}, %{
    project_id: :rand.uniform(50), skill_id: :rand.uniform(100)})
  |> Repo.insert!()
end)
