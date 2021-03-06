defmodule WhiteElephant.Item do
  use WhiteElephant.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  # @derive [Poison.Encoder]

  schema "items" do
    belongs_to :game, WhiteElephant.Game
    field :name, :string
    field :steals, :integer, default: 0
    timestamps()
  end

  @required_fields ~w(name)a
  @optional_fields ~w(steals)a
  @allowed_fields @required_fields ++ @optional_fields

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 1, max: 100)
    |> validate_number(:steals, greater_than_or_equal_to: 0)
  end

  def by_id(query, id) do
    from i in query,
      where: i.id == ^id
  end

  def for_game(query, game) do
    from i in query,
      join: g in assoc(i, :game),
      where: g.id == ^game.id
  end

  @doc """
  Creates a changeset that will increment the current number of steals

  Note: this requires that the game association be already loaded so we can validate that we're not stealing too many times
  """
  def increment(model, steal_increment \\ 1) do
    model
    |> change(%{steals: model.steals + steal_increment})
    |> validate_number(:steals, greater_than_or_equal_to: 0)
    |> validate_change(:steals, fn (:steals, steals) -> validate_steals(steals, model.game.max_steals) end)
  end

  defp validate_steals(_, 0), do: []
  defp validate_steals(steals, max_steals) when steals > max_steals do
    [steals: "must be less than %{max_steals}"]
  end
  defp validate_steals(_, _), do: []

  @doc """
  Creates a changeset that will decrement the current number of steals by the steal_increment

  Note: this requires that the game association be already loaded so we can validate that we're not stealing too many times
  """
  def decrement(model, steal_increment \\ 1) do
    increment(model, -1 * steal_increment)
  end
end

defimpl Poison.Encoder, for: WhiteElephant.Item do
  def encode(value, options) do
    value
    |> Map.take([:id, :name, :steals])
    |> Poison.Encoder.encode(options)
  end
end
