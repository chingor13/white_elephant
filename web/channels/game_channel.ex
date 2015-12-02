defmodule WhiteElephant.GameChannel do
  use WhiteElephant.Web, :channel

  def join("games:" <> game_id, _params, socket) do
    game = Repo.get(WhiteElephant.Game, game_id)
    {:ok, assign(socket, :game, game)}
  end

  # If we receive a message to create an item, we should create it
  # and then notify other people
  def handle_in("create_item", params, socket) do
    game = socket.assigns.game
    changeset = game
      |> build(:items)
      |> WhiteElephant.Item.changeset(params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        broadcast! socket, "new_item", WhiteElephant.ItemView.render("item.json", %{item: item})
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
