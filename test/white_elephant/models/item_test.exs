defmodule WhiteElephant.ItemTest do
  use WhiteElephant.DataCase

  alias WhiteElephant.{Game, Item}

  @invalid_attrs %{}

  test "changeset with only name" do
    changeset = Item.changeset(
      %Item{},
      %{"name" => "bath mat"}
    )
    assert changeset.valid?
  end

  test "changeset defaults steals to 0" do
    changeset = Item.changeset(
      %Item{},
      %{"name" => "bath mat"}
    )
    assert 0 == Ecto.Changeset.get_field(changeset, :steals)
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(
      %Item{},
      @invalid_attrs
    )
    refute changeset.valid?
  end

  test "changeset with steals" do
    changeset = Item.changeset(
      %Item{},
      %{"name" => "bath mat", "steals" => "3"}
    )
    assert changeset.valid?
    assert 3 == Ecto.Changeset.get_change(changeset, :steals)
  end

  test "increment changeset" do
    changeset = Item.increment(
      %Item{name: "name", steals: 1, game: game()}
    )
    assert changeset.valid?
    assert 2 == Ecto.Changeset.get_change(changeset, :steals)
  end

  test "increment changeset by amount" do
    changeset = Item.increment(
      %Item{name: "name", steals: 1, game: game()},
      2
    )
    assert changeset.valid?
    assert 3 == Ecto.Changeset.get_change(changeset, :steals)
  end

  test "increment changeset over max steals" do
    changeset = Item.increment(
      %Item{name: "name", steals: 3, game: game(3)}
    )
    refute changeset.valid?
  end

  test "increment changeset with unlimited steals" do
    changeset = Item.increment(
      %Item{name: "name", steals: 1, game: game_with_unlimited_steals()},
      1000
    )
    assert changeset.valid?
  end

  test "decrement changeset" do
    changeset = Item.decrement(
      %Item{name: "name", steals: 1, game: game(3)}
    )
    assert changeset.valid?
    assert 0 == Ecto.Changeset.get_change(changeset, :steals)
  end

  test "decrement changeset by amount" do
    changeset = Item.decrement(
      %Item{name: "name", steals: 3, game: game(3)},
      2
    )
    assert changeset.valid?
    assert 1 == Ecto.Changeset.get_change(changeset, :steals)
  end

  test "decrement changeset to less than 0" do
    changeset = Item.decrement(
      %Item{name: "name", steals: 0, game: game(3)}
    )
    refute changeset.valid?
  end

  defp game(max_steals \\ 3) do
    %Game{max_steals: max_steals}
  end

  defp game_with_unlimited_steals do
    game = %Game{max_steals: 0}
    assert Game.unlimited_steals?(game)
    game
  end
end
