defmodule WhiteElephant.Player do
  use WhiteElephant.Web, :model

  schema "players" do
    field :name, :string
    field :position, :integer
    belongs_to :game, WhiteElephant.Game

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :position])
    |> validate_required([:name, :position])
  end
end
