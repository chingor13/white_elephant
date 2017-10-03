defmodule WhiteElephant.ItemView do
  use WhiteElephantWeb, :view

  def render("index.json", %{items: items}) do
    items
      |> Enum.map(&as_json/1)
  end

  def render("item.json", %{item: item}) do
    as_json(item)
  end

  defp as_json(item) do
    %{id: item.id, name: item.name, steals: item.steals}
  end
end
