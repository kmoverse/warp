defmodule Warp.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :long_url, :string
    belongs_to :warp, Warp.Warp

    timestamps()
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:long_url, :warp_id])
    |> validate_required([:long_url, :warp_id])
    |> validate_url(:long_url)
  end

  defp validate_url(changeset, field) do
    case URI.parse(get_field(changeset, field)) do
      %URI{scheme: nil} ->
        add_error(changeset, field, "URL must have valid scheme")

      %URI{host: nil} ->
        add_error(changeset, field, "URL must have valid host")

      _ ->
        changeset
    end
  end
end
