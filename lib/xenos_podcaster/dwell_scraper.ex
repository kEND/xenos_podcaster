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
end
