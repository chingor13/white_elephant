defmodule WhiteElephant.PlayerTest do
  use WhiteElephant.ModelCase

  alias WhiteElephant.Player

  @valid_attrs %{name: "some content", position: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Player.changeset(%Player{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Player.changeset(%Player{}, @invalid_attrs)
    refute changeset.valid?
  end
end
