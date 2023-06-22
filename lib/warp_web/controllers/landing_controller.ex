defmodule WarpWeb.LandingController do
  use WarpWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end

  def about(conn, _params) do
    render(conn, :about)
  end
end
