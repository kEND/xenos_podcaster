defmodule XenosPodcaster.TeachingsTest do
  @moduledoc """
    case File.read(file) do
      {:ok, body}      -> # do something with the `body`
      {:error, reason} -> # handle the error caused by `reason`
    end
  """

  use ExUnit.Case

  @tag :pending
  test "scraper retrieves body#content" do
    {:ok, body_from_file} = File.read("test/support/346.html")
    {:ok, %{body: body}} = XenosPodcaster.Scraper.get_teaching_series("346")
    assert Floki.find(body_from_file, "div#content") == Floki.find(body, "div#content")
  end
end
