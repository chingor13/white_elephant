defmodule WhiteElephant.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  schema "items" do
    belongs_to :game, WhiteElephant.Game
    field :name, :string
    field :steals, :integer, default: 0
    timestamps()
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:name, :steals])
    |> validate_required(:name)
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
      |> validate_number(:steals, greater_than_or_equal_to: 0, less_than_or_equal_to: model.game.max_steals)
  end

  @doc """
  Creates a changeset that will decrement the current number of steals by the steal_increment

  Note: this requires that the game association be already loaded so we can validate that we're not stealing too many times
  """
  def decrement(model, steal_increment \\ 1) do
    increment(model, -1 * steal_increment)
  end
end
