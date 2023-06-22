defmodule Warp.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :long_url, :string
      add :warp_id, references(:warps, on_delete: :nothing)

      timestamps()
    end

    create index(:links, [:warp_id])
  end
end
