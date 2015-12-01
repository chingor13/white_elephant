defmodule WhiteElephant.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :code, :string
      add :max_steals, :integer
      add :date, :date
      timestamps
    end

  end
end
