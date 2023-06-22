defmodule WarpWeb.WarpController do
  use WarpWeb, :controller
  alias Warp.Link
  alias Warp.Warp, as: WarpObj
  alias Warp.Repo

  def warp(conn, %{"warp_id" => warp_id}) do
    hid =
      Hashids.new(
        salt: "kmoverse warp",
        min_len: 2
      )

    result = hid
    |> Hashids.decode(warp_id)
    |> decode_warp

    case result do
      {:ok, warp, other} ->
        delay = if warp.instant do 0 else 2 end
        conn
        |> render(:warp, id: warp_id, warp: warp, other: other, delay: delay)

      {:error, msg} ->
        conn
        |> render(:error, id: warp_id, error: msg)
    end
  end

  def decode_warp({:ok, [warp_id | tail]}) do
    if length(tail) > 0 do
      {:error, "Could not successfully decode ID."}
    else
      warp = Repo.get WarpObj, warp_id

      case warp do
        nil ->
          {:error, "Could not find Warp by ID"}
        %{type: :link} ->
          Repo.get_by Link, warp_id: warp_id
        _ ->
          {:error, "Unknown type of warp"}
      end
      |> case do
        nil ->
          {:error, "Could not find linked object"}
        {:error, msg} ->
          {:error, msg}
        other ->
          {:ok, warp, other}
      end
    end
  end

  def decode_warp(other) do
    other
  end

  def new(conn, _params) do
    render(conn, :new)
  end

  def index(conn, _params) do
    links = Repo.all(Link)
    warps = Repo.all(WarpObj)
    render(conn, :index, links: links, warps: warps)
  end

  def create(conn, params) do
    hid =
      Hashids.new(
        salt: "kmoverse warp",
        min_len: 2
      )

    # Test that the link is valid
    link = Link.changeset(%Link{}, %{long_url: params["long_url"], warp_id: 0})

    unless link.valid? do
      conn
      |> put_flash(:error, "Long URL is not a properly formatted URL.")
      |> render(:new)
    else
      warp = WarpObj.changeset(%WarpObj{type: :link}, params)
      {:ok, inserted} = Repo.insert(warp)

      # Update with slug!
      slug = Hashids.encode(hid, inserted.id)
      warp = Ecto.Changeset.change(inserted, slug: slug)
      Repo.update(warp)

      link = Link.changeset(%Link{}, %{long_url: params["long_url"], warp_id: inserted.id})
      {:ok, linked} = Repo.insert(link)

      conn
      |> render(:new, slug: slug, base_url: WarpWeb.Endpoint.url())
    end
  end
end
