defmodule XenosPodcasterWeb.PageController do
  use XenosPodcasterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def feed(conn, _params) do
    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("feed.xml")
  end
end
