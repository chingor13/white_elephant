defmodule WhiteElephant.ItemView do
  use WhiteElephant.Web, :view

  def render("item.json", %{item: item}) do
    %{id: item.id, name: item.name, steals: item.steals}
  end
end
