defmodule XenosPodcasterWeb.PageView do
  use XenosPodcasterWeb, :view

  def make_safe(string), do: html_escape(string) |> safe_to_string()
end
