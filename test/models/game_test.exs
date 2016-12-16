defmodule WhiteElephant.GameTest do
  use WhiteElephant.ModelCase

  alias WhiteElephant.Game

  @valid_attrs %{"name" => "Foobar", "max_steals" => "3", "date" => "2016-12-14"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Game.changeset(%Game{}, @invalid_attrs)
    refute changeset.valid?
  end
end
