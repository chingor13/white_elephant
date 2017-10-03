defmodule WhiteElephantWeb.ItemTest do
  use WhiteElephant.DataCase

  alias WhiteElephant.Item

  @valid_attrs %{"name" => "bath mat"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
