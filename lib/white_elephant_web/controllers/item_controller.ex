defmodule WhiteElephantWeb.ItemController do
  use WhiteElephantWeb, :controller

  alias WhiteElephant.{Item, Repo}

  plug :scrub_params, "item" when action in [:create, :update]
  plug :load_game

  def new(conn, _params) do
    item = conn |> get_game |> Ecto.build_assoc(:items)
    changeset = Item.changeset(item)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    item = conn |> get_game |> Ecto.build_assoc(:items)
    changeset = Item.changeset(item, item_params)

    case Repo.insert(changeset) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: game_path(conn, :show, conn.assigns[:game]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
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
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: game_path(conn, :show, conn.assigns[:game]))
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
    |> redirect(to: game_path(conn, :show, conn.assigns[:game]))
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
    import Ecto.Query, only: [from: 2]
    game = get_game(conn)
    id = conn.params["id"]
    (from i in Item, where: i.id == ^id)
      |> Item.for_game(game)
      |> Repo.one!
  end
end
