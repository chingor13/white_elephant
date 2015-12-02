defmodule WhiteElephant.ItemController do
  use WhiteElephant.Web, :controller

  alias WhiteElephant.Item

  plug :scrub_params, "item" when action in [:create, :update]
  plug :load_game

  def index(conn, _params) do
    game = conn |> get_game |> Repo.preload(:items)
    render(conn, "index.html", items: game.items)
  end

  def new(conn, _params) do
    item = conn |> get_game |> Ecto.Model.build(:items)
    changeset = Item.changeset(item)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    item = conn |> get_game |> Ecto.Model.build(:items)
    changeset = Item.changeset(item, item_params)

    case Repo.insert(changeset) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: game_item_path(conn, :index, conn.assigns[:game]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => _id}) do
    item = conn |> find_item
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => _id}) do
    item = conn |> find_item
    changeset = Item.changeset(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => _id, "item" => item_params}) do
    item = conn |> find_item
    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: game_item_path(conn, :show, conn.assigns[:game], item))
      {:error, changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}) do
    item = conn |> find_item

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: game_item_path(conn, :index, conn.assigns[:game]))
  end

  defp load_game(conn, _) do
    game = Repo.get!(WhiteElephant.Game, conn.params["game_id"])

    conn
      |> assign(:game, game)
  end

  defp get_game(conn) do
    conn.assigns[:game]
  end

  defp find_item(conn) do
    game = get_game(conn)
    id = conn.params["id"]
    (from i in Item, where: i.id == ^id)
      |> Item.for_game(game)
      |> Repo.one!
  end
end
