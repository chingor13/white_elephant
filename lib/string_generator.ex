defmodule StringGenerator do
  @chars "ABCDEFGHJKLMNPQRSTUVWXYZ23456789" |> String.codepoints()

  def string_of_length(length) do
    (1..length)
    |> Enum.map(fn (_) -> Enum.random(@chars) end)
    |> Enum.join("")
  end
end
