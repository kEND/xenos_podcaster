defmodule XenosPodcasterWeb.PageController do
  use XenosPodcasterWeb, :controller
  alias XenosPodcaster.{Teachings, SeriesCache}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def feed(conn, %{"series" => series_no}) do
    series = SeriesCache.fetch(series_no, fn ->
        Teachings.series(series_no)
      end)

    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("feed.xml", series: series)
  end
end
