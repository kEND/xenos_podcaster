defmodule XenosPodcaster.SeriesDataTest do
  use ExUnit.Case

  alias XenosPodcaster.DwellScraper
  alias XenosPodcaster.SeriesData

  describe "SeriesData.populate/2" do
    test "set series" do
      expected_series_data = %SeriesData{
        series: "Hebrews by Dennis McCallum (2015)",
        subtitle: "Hebrews by Dennis McCallum (2015)",
        teachings_urls: [
          "/teaching/3049",
          "/teaching/3059",
          "/teaching/3062",
          "/teaching/3076",
          "/teaching/3083",
          "/teaching/3088",
          "/teaching/3094",
          "/teaching/3099",
          "/teaching/3104",
          "/teaching/3127",
          "/teaching/3122",
          "/teaching/3226",
          "/teaching/3140",
          "/teaching/3147",
          "/teaching/3153",
          "/teaching/3155",
          "/teaching/3160",
          "/teaching/3166",
          "/teaching/3168",
          "/teaching/3230",
          "/teaching/3224",
          "/teaching/3229",
          "/teaching/3236"
        ],
        teachings: [],
        url: "https://teachings.dwellcc.org/series/245"
      }

      series_id = "245"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(series_id)

      assert SeriesData.populate(body, series_id) == expected_series_data
    end

    test "get urls to teaching pages on summary page" do
      expected_teaching_urls = [
        "/teaching/1493",
        "/teaching/1501",
        "/teaching/1502",
        "/teaching/1505",
        "/teaching/3000"
      ]

      series_id = "120"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(series_id)

      assert SeriesData.teaching_urls(body) == expected_teaching_urls
    end

    test "get urls to teaching pages from additional pages" do
      expected_teaching_urls = [
        "/teaching/3049",
        "/teaching/3059",
        "/teaching/3062",
        "/teaching/3076",
        "/teaching/3083",
        "/teaching/3088",
        "/teaching/3094",
        "/teaching/3099",
        "/teaching/3104",
        "/teaching/3127",
        "/teaching/3122",
        "/teaching/3226",
        "/teaching/3140",
        "/teaching/3147",
        "/teaching/3153",
        "/teaching/3155",
        "/teaching/3160",
        "/teaching/3166",
        "/teaching/3168",
        "/teaching/3230",
        "/teaching/3224",
        "/teaching/3229",
        "/teaching/3236"
      ]

      series_id = "245"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(series_id)

      additional_pages = DwellScraper.additional_pages(body)
      teaching_urls = SeriesData.teaching_urls(body)

      assert teaching_urls ++ SeriesData.teaching_urls(additional_pages) == expected_teaching_urls
    end
  end
end
