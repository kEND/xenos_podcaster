defmodule XenosPodcaster.SeriesData do
  defstruct [
    :series,
    :book,
    teachings_urls: [],
    teachings: []
  ]

  alias XenosPodcaster.DwellScraper

  def populate(floki_item) do
    ["Book: " <> book | [series]] =
      Floki.find(floki_item, "#active-filters li") |> Floki.text() |> String.split(" Series: ")

    additional_pages = DwellScraper.additional_pages(floki_item)

    %__MODULE__{
      series: String.trim(series),
      book: book,
      teachings_urls: teaching_urls(floki_item) ++ teaching_urls(additional_pages),
      teachings: []
    }
  end

  def teaching_urls(page_urls) when is_list(page_urls) do
    page_urls
    |> Enum.reduce([], fn page_url, teaching_page_urls ->
      {:ok, %{body: body}} = XenosPodcaster.DwellScraper.get_teaching_page(page_url)
      teaching_page_urls ++ teaching_urls(body)
    end)
    |> List.flatten()
  end

  def teaching_urls(body) do
    Floki.find(body, "[data-key]")
    |> Enum.map(fn x ->
      Floki.find(x, "a")
      |> Floki.attribute("href")
      |> Floki.text()
    end)
  end
end
