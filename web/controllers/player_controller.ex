defmodule WhiteElephant.PlayerController do
  use WhiteElephant.Web, :controller

  alias WhiteElephant.Player

  plug :scrub_params, "player" when action in [:create, :update]
  plug :load_game

  def new(conn, _params) do
    player = conn |> get_game |> Ecto.Model.build(:players)
    changeset = Player.changeset(player)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"player" => player_params}) do
    player = conn |> get_game |> Ecto.Model.build(:players)
    changeset = Player.changeset(Player, player_params)

    case Repo.insert(changeset) do
      {:ok, _player} ->
        conn
        |> put_flash(:info, "Player created successfully.")
        |> redirect(to: game_path(conn, :show, conn.assigns[:game]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => _id}) do
    player = conn |> find_player
    changeset = Player.changeset(player)
    render(conn, "edit.html", player: player, changeset: changeset)
  end

  def update(conn, %{"id" => _id, "player" => player_params}) do
    player = conn |> find_player
    changeset = Player.changeset(player, player_params)

    case Repo.update(changeset) do
      {:ok, _player} ->
        conn
        |> put_flash(:info, "Player updated successfully.")
        |> redirect(to: game_path(conn, :show, conn.assigns[:game]))
      {:error, changeset} ->
        render(conn, "edit.html", player: player, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}) do
    player = conn |> find_player

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(player)

    conn
    |> put_flash(:info, "Player deleted successfully.")
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

  defp find_player(conn) do
    game = get_game(conn)
    id = conn.params["id"]
    (from i in Player, where: i.id == ^id)
      |> Player.for_game(game)
      |> Repo.one!
  end
end
