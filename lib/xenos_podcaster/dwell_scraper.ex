defmodule XenosPodcaster.DwellScraper do
  @site "https://teachings.dwellcc.org"
  def get_teaching_series(book, series_id) do
    get(@site <> "/?book=" <> book <> "&" <> "SeriesID=" <> series_id)
  end

  #  maybe remove book and just go back to series id

  def get_teaching_page(path), do: get(@site <> path)

  defp get(url) do
    case HTTPoison.get(url, [], follow_redirect: true, max_redirect: 5) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, %{body: body}}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  def additional_pages(body) do
    case Floki.find(body, "[data-page]") do
      [] ->
        []

      [_ | rest] ->
        Enum.filter(rest, fn {"a", _, [x]} -> x in ["2", "3", "4"] end)
        |> Enum.map(fn {"a", [{_, page_path}, _], _} -> page_path end)
    end
  end

  def populate(body, series_id) do
    XenosPodcaster.SeriesData.populate(body, series_id)
  end

  def populate_teachings(series_data) do
    %{
      series_data
      | teachings:
          series_data.teachings_urls
          |> Enum.map(fn path ->
            {:ok, %{body: body}} = get_teaching_page(path)
            XenosPodcaster.TeachingData.populate(body)
          end)
    }
  end

  def populate_author_image_and_date(series_data) do
    series_data
    |> XenosPodcaster.SeriesData.set_author()
    |> XenosPodcaster.SeriesData.set_author_image()
    |> XenosPodcaster.SeriesData.set_series_date()
    |> XenosPodcaster.SeriesData.set_teaching_urls()
  end

  def populate_series_and_teachings(book, series_id) do
    {:ok, %{body: body}} = get_teaching_series(book, series_id)

    body
    |> populate(series_id)
    |> populate_teachings()
    |> populate_author_image_and_date()
  end
end
