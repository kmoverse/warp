defmodule Warp.Warp do
  use Ecto.Schema
  import Ecto.Changeset

  schema "warps" do
    field :instant, :boolean, default: false
    field :namespace, :string
    field :slug, :string
    field :type, Ecto.Enum, values: [:link, :text, :code, :graph]
    has_one :link, Warp.Link

    timestamps()
  end

  @doc false
  def changeset(warp, attrs \\ %{}) do
    warp
    |> cast(attrs, [:slug, :namespace, :instant, :type])
    |> validate_required([:instant, :type])
    |> validate_inclusion(:type, [:link])
    |> unique_constraint([:slug, :namespace])
  end
end
