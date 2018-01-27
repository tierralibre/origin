defmodule Ui.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :type, :string
      add :uuid, :string
      add :data, :string
      
      timestamps()
    end

  end
end
