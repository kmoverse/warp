defmodule WarpWeb.WarpHTML do
  use WarpWeb, :html
  import Phoenix.HTML.Form

  embed_templates "warp_html/*"
end
