defmodule WhiteElephant.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email_address, :string
      add :uid, :string
      add :token, :string

      timestamps
    end

  end
end
