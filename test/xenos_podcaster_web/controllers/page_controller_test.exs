defmodule XenosPodcasterWeb.PageControllerTest do
  use XenosPodcasterWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Podcaster!"
  end
end
