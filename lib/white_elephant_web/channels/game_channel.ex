defmodule WhiteElephantWeb.GameChannel do
  use WhiteElephantWeb, :channel
  alias WhiteElephant.{Game, Item, Repo}

  def join("games:" <> game_id, _params, socket) do
    game = Repo.get(Game, game_id)
    {:ok, assign(socket, :game, game)}
  end

  # If we receive a message to create an item, we should create it
  # and then notify other people
  def handle_in("create_item", params, socket) do
    game = socket.assigns.game
    changeset =
      game
      |> Ecto.build_assoc(:items)
      |> Item.changeset(params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        broadcast! socket, "item_created", item
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def handle_in("remove_item", %{"id" => item_id}, socket) do
    item =
      socket.assigns.game
      |> Ecto.assoc(:items)
      |> Repo.get(item_id)

    case Repo.delete(item) do
      {:ok, item} ->
        broadcast! socket, "item_deleted", item
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def handle_in("steal_item", %{"id" => item_id}, socket) do
    changeset =
      socket.assigns.game
      |> Ecto.assoc(:items)
      |> Repo.get(item_id)
      |> Map.put(:game, socket.assigns.game)
      |> Item.increment()

    case Repo.update(changeset) do
      {:ok, item} ->
        broadcast! socket, "item_updated", item
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def handle_in("undo_steal_item", %{"id" => item_id}, socket) do
    changeset =
      socket.assigns.game
      |> Ecto.assoc(:items)
      |> Repo.get(item_id)
      |> Map.put(:game, socket.assigns.game)
      |> Item.decrement()

    case Repo.update(changeset) do
      {:ok, item} ->
        broadcast! socket, "item_updated", item
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
