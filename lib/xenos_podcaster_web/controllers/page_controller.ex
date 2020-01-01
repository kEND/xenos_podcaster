defmodule XenosPodcasterWeb.PageController do
  use XenosPodcasterWeb, :controller
  alias XenosPodcaster.Teachings

  def index(conn, _params) do
    if series_url = get_session(conn, :series_url) do
      conn = put_session(conn, :series_url, "https://www.xenos.org/teachings/?series=346")
    end

    render(conn, "index.html", series_url: series_url)
  end

  def feed(conn, _params) do
    series_url = get_session(conn, :series_url)

    series = Teachings.series(series_url)
    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("feed.xml", series: series)
  end

  def set_series(conn, %{"series_url" => series_url}) do
    conn
    |> put_session(:series_url, series_url)
    |> redirect(to: Routes.page_path(conn, :feed))
  end
end
