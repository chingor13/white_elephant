defmodule WhiteElephant.Item do
  use WhiteElephant.Web, :model

  schema "items" do
    belongs_to :game, WhiteElephant.Game
    field :name, :string
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
end
