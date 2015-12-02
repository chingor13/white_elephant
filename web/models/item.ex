defmodule WhiteElephant.Item do
  use WhiteElephant.Web, :model

  schema "items" do
    belongs_to :game, WhiteElephant.Game
    field :name, :string
    field :steals, :integer, default: 0
    timestamps
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
    |> cast(params, @required_fields, @optional_fields)
  end

  def for_game(query, game) do
    from i in query,
      join: g in assoc(i, :game),
      where: g.id == ^game.id
  end
end
