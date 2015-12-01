defmodule WhiteElephant.Game do
  use WhiteElephant.Web, :model

  schema "games" do
    field :name, :string
    field :code, :string
    field :max_steals, :integer
    field :date, Ecto.Date
    has_many :items, WhiteElephant.Item
    timestamps
  end

  @required_fields ~w(name max_steals date)
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
