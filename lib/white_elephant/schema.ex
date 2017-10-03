defmodule WhiteElephant.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :id, autogenerate: true}
      @foreign_key_type :id
    end
  end
end
