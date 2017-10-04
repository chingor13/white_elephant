defmodule WhiteElephant.GameEncodingTest do
  use WhiteElephant.DataCase

  alias WhiteElephant.{Game, Item}

  test "Poison.encode!" do
    game = %Game{
      name: "Test Game",
      max_steals: 3,
      items: [
        %Item{name: "Bath mat", steals: 1},
        %Item{name: "Holiday mug"}
      ]
    }
    assert {:ok, _json} = Poison.encode(game)
  end
end
