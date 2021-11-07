defmodule XenosPodcaster.DwellScraperTest do
  @moduledoc """
    case File.read(file) do
      {:ok, body}      -> # do something with the `body`
      {:error, reason} -> # handle the error caused by `reason`
    end
  """
  use ExUnit.Case

  alias XenosPodcaster.DwellScraper

  describe "DwellScraper" do
    test "hits main dwellcc.org teachings page" do
      book = "58"
      series_id = "245"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(book, series_id)
      assert body =~ "Hebrews by Dennis McCallum (2015)"
    end
  end

end
