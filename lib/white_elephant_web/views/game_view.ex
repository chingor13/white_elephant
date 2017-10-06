defmodule WhiteElephantWeb.GameView do
  use WhiteElephantWeb, :view

  def render("items.json", %{game: game}) do
    Poison.encode!(game.items)
  end
end
