defmodule WhiteElephant.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :game_id, references(:games)
      add :name, :string
      add :steals, :integer, default: 0
      timestamps
    end

  end
end
