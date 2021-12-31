defmodule XenosPodcasterWeb.PageController do
  use XenosPodcasterWeb, :controller
  alias XenosPodcaster.DwellScraper
  alias XenosPodcaster.SeriesCache

  def index(conn, _params) do
    render(conn, "index.html")
  end


  def feed(conn, %{"series" => series_id}) do
    series =
      SeriesCache.fetch(series_id, fn ->
        DwellScraper.populate_series_and_teachings(series_id)
      end)

    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("feed.xml", series: series)
  end
end
