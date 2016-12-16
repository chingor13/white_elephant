defmodule StringGenerator do
  @chars "ABCDEFGHJKLMNPQRSTUVWXYZ23456789" |> String.split("")

  def string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end
end
