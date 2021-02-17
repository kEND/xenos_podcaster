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

  test "author from series body" do
    {:ok, body} = File.read("test/support/245.html")
    {:ok, body2} = File.read("test/support/346.html")

    assert XenosPodcaster.Teachings.series_author(body) == "Dennis McCallum"
    assert XenosPodcaster.Teachings.series_author(body2) == "Ben Foust"
  end

  test "provide default series author if none exists" do
    {:ok, body} = File.read("test/support/359.html")
    assert XenosPodcaster.Teachings.series_author(body) == "Various Teachers"
  end

  test "failing" do
    {:ok, body} = File.read("test/support/258.html")
    assert XenosPodcaster.Teachings.series_author(body) == "Dennis McCallum"
  end
end
