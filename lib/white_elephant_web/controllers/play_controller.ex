defmodule WhiteElephantWeb.PlayController do
  use WhiteElephantWeb, :controller

  alias WhiteElephant.Game

  plug :put_layout, "play.html"

  def play(conn, %{"game_code" => game_code}) do
    with query <- Game.by_code(Game, game_code),
         game = %Game{} <- Repo.one(query),
         game = Repo.preload(game, :items)
    do
      render conn, "play.html", game: game
    else
      _ ->
        conn
        |> put_flash(:error, "Could not find game '#{game_code}'")
        |> redirect(to: game_path(conn, :index))
    end
  end
end
