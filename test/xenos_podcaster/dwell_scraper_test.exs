defmodule XenosPodcaster.DwellScraperTest do
  @moduledoc """
    case File.read(file) do
      {:ok, body}      -> # do something with the `body`
      {:error, reason} -> # handle the error caused by `reason`
    end
  """
  use ExUnit.Case

  alias XenosPodcaster.DwellScraper

  describe "DwellScraper hitting main dwellcc.org teachings page with book and series" do
    test "finds Hebrews(58) 2015 series by Dennis (245)" do
      book = "58"
      series_id = "245"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(book, series_id)
      assert body =~ "Hebrews by Dennis McCallum (2015)"
    end

    test "recognizes that there are pages of teachings" do
      book = "58"
      series_id = "245"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(book, series_id)

      expected_additional_pages = [
        "/?book=58&SeriesID=245&page=2&per-page=10",
        "/?book=58&SeriesID=245&page=3&per-page=10"
      ]

      assert DwellScraper.additional_pages(body) == expected_additional_pages
    end

    test "recognizes short series has no additional pages" do
      book = "60"
      series_id = "120"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(book, series_id)
      assert DwellScraper.additional_pages(body) == []
    end

    @tag :pending
    test "yields a list of individual teaching pages" do
      book = "58"
      series_id = "245"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(book, series_id)

      expected_teaching_page_urls = [
      ]

      assert DwellScraper.teaching_pages(body) == expected_teaching_page_urls
    end
  end
end
