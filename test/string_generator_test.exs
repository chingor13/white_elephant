defmodule StringGeneratorTest do
  use ExUnit.Case

  test "generates valid characters" do
    string = StringGenerator.string_of_length(8)
    assert string =~ ~r/[A-Z0-9]{8}/
  end

  test "generates valid length" do
    length = Enum.random(1..100)
    string = StringGenerator.string_of_length(length)
    assert length == String.length(string)
  end
end
