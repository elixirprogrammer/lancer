# Lancer Made By [Anthony Gonzalez](https://github.com/boilercoding/ "Anthony Gonzalez Github")

[Lancer](https://lancer-elixir-freelancer-clone.herokuapp.com "Lancer") freelancer clone made with elixir/phoenix.

![Lancer Homepage](/lancer-readme-img/homepage.png "Lancer Homepage")

### [_See Lancer on Heroku here_](https://lancer-elixir-freelancer-clone.herokuapp.com "Lancer")

You are encouraged to create an account, but if you want to get a feel of Lancer first, you may log in with any of the following users (all having a password of `password123`):

- penelope1985
- maymie2011
- elta_wisoky
- kaitlyn.franecki
- keegan2016
- lila_mayert
- vanessa2068
- elfrieda.hilll
- jarod2043
- thad.blick


## Main Features

1. [Log in required to view content](#log-in-required "Log In Required")
1. [Edit Account](#Edit-Account "Edit Account")
1. [Jobs](#jobs "Jobs")
1. [Pagination](#pagination "Pagination")
1. [My Jobs](#my-jobs "My Jobs")
1. [Proposals](#proposals "Proposals")

## Details of Main Features

#### Log In Required

![LancerLog in Page](/lancer-readme-img/login.png "Lancer Log in Page")

Not logged in users can only see the jobs. I didn't use any packages, I made the authentication from scratch.

#### Edit Account

![Lancer Edit Account Page](/lancer-readme-img/edit-account.png "Lancer Edit Account Page")
Users have the ability to edit their accounts.


#### Jobs

![Lancer Add Job Page](/lancer-readme-img/new-job.png "Lancer Add Job Page")

Logged in users can posts jobs and submit proposals.


#### Pagination

Pagination for jobs are done with the [Kerosene](https://github.com/elixirdrops/kerosene "Kerosene") package.


#### My Jobs

![Lancer My Jobs Page](/lancer-readme-img/manage-jobs.png "Lancer My Jobs Page")

Users can manage their posted jobs.


#### Proposals

![Lancer View Jobs Page](/lancer-readme-img/view-job.png "Lancer View Jobs Page")

Users can submit proposals to jobs and the owner of that proposal can award a proposal.

---

If you've made it through reading all this, congratulation...now you really should head over to [**_Lancer_**](https://lancer-elixir-freelancer-clone.herokuapp.com "Lancer").

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).
