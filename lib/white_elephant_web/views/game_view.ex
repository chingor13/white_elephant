defmodule WhiteElephantWeb.GameView do
  use WhiteElephantWeb, :view

  def render("items.json", %{game: game}) do
    WhiteElephantWeb.ItemView.render("index.json", items: game.items)
      |> Poison.encode!
  end
end
