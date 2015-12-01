# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WhiteElephant.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

WhiteElephant.Repo.insert!(%WhiteElephant.Game{id: 1, name: "2015 Holiday Party", max_steals: 3, date: "2015-12-05"})
WhiteElephant.Repo.insert!(%WhiteElephant.Item{game_id: 1, name: "Pyrex Mixing Bowls", steals: 1})
WhiteElephant.Repo.insert!(%WhiteElephant.Item{game_id: 1, name: "Shower Mat", steals: 2})