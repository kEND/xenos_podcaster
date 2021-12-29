defmodule XenosPodcaster.SeriesData do
  defstruct [
    :series,
    :author,
    :url,
    :last_build_date,
    :image_url,
    :subtitle,
    teachings_urls: [],
    teachings: []
  ]

  alias XenosPodcaster.DwellScraper

  def populate(floki_item, series) do
    additional_pages = DwellScraper.additional_pages(floki_item)

    %__MODULE__{
      series: series_title(floki_item),
      url: "https://teachings.dwellcc.org/series/" <> series,
      subtitle: series_title(floki_item),
      teachings_urls: teaching_urls(floki_item) ++ teaching_urls(additional_pages),
      teachings: []
    }
  end

  def series_title(floki_item) do
    floki_item
    |> Floki.find(".series-title")
    |> Floki.text()
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

  def set_author(%__MODULE__{teachings: []} = series_data) do
    %{series_data | author: "no teachings"}
  end

  def set_author(%__MODULE__{teachings: [first_teaching | _rest]} = series_data) do
    %{series_data | author: first_teaching.author}
  end

  def set_author_image(%__MODULE__{teachings: []} = series_data), do: series_data

  def set_author_image(%__MODULE__{teachings: [first_teaching | _rest]} = series_data) do
    %{series_data | image_url: first_teaching.image_url}
  end

  def set_series_date(%__MODULE__{teachings: []} = series_data), do: series_data
  def set_series_date(%__MODULE__{} = series_data) do
    last_teaching = List.last(series_data.teachings)
    %{series_data | last_build_date: last_teaching.date}
  end

  def set_teaching_urls(%__MODULE__{teachings: []} = series_data), do: series_data
  def set_teaching_urls(%__MODULE__{teachings: teachings, teachings_urls: teachings_urls} = series_data) do
    teachings =
      Enum.zip_with(teachings, teachings_urls, fn teaching, url ->
        teaching = %{teaching | url: "https://teachings.dwellcc.org" <> url}
        %{teaching | xenos_teaching_id: url |> String.split("/") |> List.last()}
      end)

    %{series_data | teachings: teachings}
  end
end
