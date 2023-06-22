defmodule Warp.Repo.Migrations.CreateWarps do
  use Ecto.Migration

  def change do
    create table(:warps) do
      add :slug, :string
      add :namespace, :string
      add :instant, :boolean, default: false, null: false
      add :type, :string

      timestamps()
    end
  end
end
