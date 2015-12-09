defmodule WhiteElephant.User do
  use WhiteElephant.Web, :model

  alias WhiteElephant.User
  alias WhiteElephant.Repo

  schema "users" do
    field :name, :string
    field :email_address, :string
    field :uid, :string
    field :token, :string

    timestamps
  end

  @required_fields ~w(name email_address uid token)
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

  def find_or_create(%{provider: :facebook, uid: uid, credentials: %{token: token}, info: %{name: name, email: email_address}}) do

    (from u in User, where: u.uid == ^uid)
     |> Repo.one
     |> find_or_create(%{uid: uid, name: name, token: token, email_address: email_address})
   end

  defp find_or_create(nil, params) do
    changeset(%User{}, params)
      |> Repo.insert
  end
  defp find_or_create(user = %User{}, _params) do
    {:ok, user}
  end
end
