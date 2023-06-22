defmodule Warp.Repo.Migrations.SetUniqueSlugIndex do
  use Ecto.Migration

  def change do
    create unique_index(:warps, [:slug, :namespace])
  end
end
