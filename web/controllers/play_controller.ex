defmodule WhiteElephant.PlayController do
  use WhiteElephant.Web, :controller

  alias WhiteElephant.Game

  plug :put_layout, "play.html"

  def play(conn, %{"game_code" => game_code}) do
    game = Repo.one!(Game |> Game.by_code(game_code))
      |> Repo.preload(:items)
    render conn, "play.html", game: game
  end
end
