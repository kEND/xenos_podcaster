defmodule XenosPodcaster.SeriesDataTest do
  use ExUnit.Case

  alias XenosPodcaster.DwellScraper
  alias XenosPodcaster.SeriesData
  alias XenosPodcaster.TeachingData

  describe "" do
    @tag :pending
    test "" do
      floki_teaching_summary_item =
        {"div", [{"data-key", "3049"}],
         [
           {"a", [{"href", "/teaching/3049"}],
            [
              {"div", [{"class", "teaching-item grid-x grid-margin-x"}],
               [
                 {:comment, " <div class=\"teaching-item grid-x\"> "},
                 {:comment, " <div class=\"teaching-item grid-y\"> "},
                 {:comment,
                  " <div class=\"teaching-title cell medium-4 show-for-medium\">Introduction</div> "},
                 {:comment,
                  " <div class=\"teaching-title-abbr cell small-5 hide-for-medium\">Introduction</div> "},
                 {:comment,
                  " <div class=\"teaching-title cell medium-auto show-for-medium\">Introduction</div> "},
                 {:comment,
                  " <div class=\"teaching-title-abbr cell medium-auto hide-for-medium\">Introduction</div> "},
                 {"div", [{"class", "teaching-title cell medium-auto hide-for-medium-only"}],
                  ["Introduction"]},
                 {"div", [{"class", "teaching-title-abbr cell medium-auto show-for-medium-only"}],
                  ["Introduction"]},
                 {"div", [{"class", "author cell medium-auto"}], ["Dennis McCallum"]},
                 {:comment,
                  " <div class=\"passage cell medium-auto show-for-large\">Hebrews&nbsp;1:1-2:3</div> "},
                 {:comment,
                  " <div class=\"passage-abbr cell medium-auto hide-for-large\">Heb&nbsp;1:1-2:3</div> "},
                 {"div", [{"class", "passage cell medium-auto hide-for-medium-only"}],
                  ["Hebrews 1:1-2:3"]},
                 {"div", [{"class", "passage-abbr cell medium-auto show-for-medium-only"}],
                  ["Heb 1:1-2:3"]},
                 {:comment, " <div class=\"year cell medium-auto show-for-large\">2015</div> "},
                 {:comment, " <div class=\"year cell large-1 show-for-large\">2015</div> "},
                 {"div", [{"class", "year cell medium-auto hide-for-medium-only"}], ["2015"]}
               ]}
            ]}
         ]}

      expected_series_data = %SeriesData{
        series: "",
        book: "",
        teachings_urls: ["/teaching/3049"],
        teachings: [
          %TeachingData{
            author: "Dennis McCallum",
            url: "/teaching/3049",
            verse_range: "Hebrews 1:1-2:3"
          },
          %TeachingData{
            author: "Dennis McCallum",
            url: "/teaching/3049",
            verse_range: "Hebrews 1:1-2:3"
          }
        ]
      }

      assert SeriesData.populate(floki_teaching_summary_item) == expected_series_data
    end

    test "set series and book" do
      expected_series_data = %SeriesData{
        series: "Hebrews by Dennis McCallum (2015)",
        book: "Hebrews",
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
        teachings: []
      }

      book = "58"
      series_id = "245"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(book, series_id)

      assert SeriesData.populate(body) == expected_series_data
    end

    test "get urls to teaching pages on summary page" do
      expected_teaching_urls = [
        "/teaching/1493",
        "/teaching/1501",
        "/teaching/1502",
        "/teaching/1505",
        "/teaching/3000"
      ]

      book = "60"
      series_id = "120"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(book, series_id)

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

      book = "58"
      series_id = "245"
      {:ok, %{body: body}} = DwellScraper.get_teaching_series(book, series_id)

      additional_pages = DwellScraper.additional_pages(body)
      teaching_urls = SeriesData.teaching_urls(body)

      assert teaching_urls ++ SeriesData.teaching_urls(additional_pages) == expected_teaching_urls
    end
  end
end
