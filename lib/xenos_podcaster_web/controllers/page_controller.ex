defmodule XenosPodcasterWeb.PageController do
  use XenosPodcasterWeb, :controller
  alias XenosPodcaster.Teachings

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def feed(conn, %{"series" => series}) do
    series = Teachings.series("https://xenos.org/teachings/?series=" <> series)
    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("feed.xml", series: series)
  end
end
