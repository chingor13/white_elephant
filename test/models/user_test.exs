defmodule WhiteElephant.UserTest do
  use WhiteElephant.ModelCase

  alias WhiteElephant.User

  @valid_attrs %{email_address: "some content", name: "some content", uid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
