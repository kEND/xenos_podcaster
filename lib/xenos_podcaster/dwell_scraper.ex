defmodule XenosPodcaster.DwellScraper do
  @site "https://teachings.dwellcc.org"
  def get_teaching_series(book, series_id) do
    get(@site <> "/?book=" <> book <> "&" <> "SeriesID=" <> series_id)
  end

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

  def populate(body) do
    XenosPodcaster.SeriesData.populate(body)
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

  def populate_author_and_image(series_data) do
    series_data
    |> XenosPodcaster.SeriesData.set_author()
    |> XenosPodcaster.SeriesData.set_author_image()
  end

  def populate_series_and_teachings(body) do
    body
    |> populate()
    |> populate_teachings()
    |> populate_author_and_image()
  end
end
