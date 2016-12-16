defmodule WhiteElephant.PlayerView do
  use WhiteElephant.Web, :view

  def render("index.json", %{players: players}) do
    players
      |> Enum.map(&as_json/1)
  end

  def render("player.json", %{player: player}) do
    as_json(player)
  end

  defp as_json(player) do
    %{id: player.id, name: player.name}
  end
end
