defmodule WhiteElephant.Game do
  use WhiteElephant.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  # @derive [Poison.Encoder]

  schema "games" do
    field :name, :string
    field :code, :string
    field :max_steals, :integer
    field :date, :date
    has_many :items, WhiteElephant.Item, on_delete: :delete_all
    timestamps()
  end

  @required_fields ~w(name max_steals date)a

  def by_code(query, code) do
    from g in query,
      where: g.code == ^code
  end

  def unlimited_steals?(%{max_steals: 0}),  do: true
  def unlimited_steals?(_),                 do: false

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> set_default_code()
    |> validate_length(:name, min: 1, max: 100)
    |> validate_number(:max_steals, greater_than_or_equal_to: 0)
  end

  defp set_default_code(changeset) do
    case fetch_field(changeset, :code) do
      {:data, nil} ->
        put_change(changeset, :code, StringGenerator.string_of_length(6))
      _ ->
        changeset
    end
  end
end

defimpl Poison.Encoder, for: WhiteElephant.Game do
  def encode(value, options) do
    value
    |> Map.take([:id, :name, :max_steals, :items])
    |> Map.put(:items, Enum.map(value.items, &Poison.Encoder.encode(&1, options)))
    |> Poison.Encoder.encode(options)
  end
end
