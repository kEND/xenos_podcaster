defmodule XenosPodcasterWeb.PageController do
  use XenosPodcasterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
