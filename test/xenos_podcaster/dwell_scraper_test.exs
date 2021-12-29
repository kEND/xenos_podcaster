defmodule XenosPodcaster.DwellScraperTest do
  @moduledoc """
    case File.read(file) do
      {:ok, body}      -> # do something with the `body`
      {:error, reason} -> # handle the error caused by `reason`
    end
  """
  use ExUnit.Case

  alias XenosPodcaster.DwellScraper

  describe "DwellScraper hitting main dwellcc.org teachings page with  series" do
    test "finds Hebrews 2015 series by Dennis (245)" do
      series_id = "245"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(series_id)
      assert body =~ "Hebrews by Dennis McCallum (2015)"
    end

    test "should yield a list of teaching pages by url" do
      series_id = "245"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(series_id)

      expected_teaching_pages = %XenosPodcaster.SeriesData{
        series: "Hebrews by Dennis McCallum (2015)",
        subtitle: "Hebrews by Dennis McCallum (2015)",
        teachings: [],
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
        url: "https://teachings.dwellcc.org/series/245"
      }

      assert DwellScraper.populate(body, series_id) == expected_teaching_pages
    end

    test "recognizes short series has no additional pages" do
      series_id = "120"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(series_id)
      assert DwellScraper.additional_pages(body) == []
    end
  end
end
