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

  def by_code(query, code) do
    from g in query,
      where: g.code == ^code
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> set_default_code
    |> validate_length(:name, min: 1, max: 100)
    |> validate_number(:max_steals, greater_than_or_equal_to: 0)
  end

  @doc """
  Generates a random code for the model if one isn't already set
  """
  defp set_default_code(changeset) do
    case fetch_field(changeset, :code) do
      {:data, nil} ->
        put_change(changeset, :code, StringGenerator.string_of_length(6))
      _ ->
        changeset
    end
  end

end
