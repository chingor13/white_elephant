defmodule WhiteElephantWeb.PlayController do
  use WhiteElephantWeb, :controller

  alias WhiteElephant.{Game, Repo}

  plug :put_layout, "play.html"

  def play(conn, %{"game_code" => game_code}) do
    require Ecto.Query
    Game
    |> Game.by_code(game_code)
    |> Ecto.Query.preload(:items)
    |> Repo.one
    |> case do
      nil ->
        conn
        |> put_flash(:error, "Could not find game '#{game_code}'")
        |> redirect(to: game_path(conn, :index))
      game ->
        render conn, "play.html", game: game
    end
  end
end
