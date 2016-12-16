defmodule WhiteElephant.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :position, :integer
      add :game_id, references(:games, on_delete: :nothing)

      timestamps()
    end
    create index(:players, [:game_id])

  end
end
