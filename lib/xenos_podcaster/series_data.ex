defmodule XenosPodcaster.SeriesData do
  defstruct [
    :series,
    :book,
    teachings_urls: [],
    teachings: []
  ]

  def populate(floki_item) do
    ["Book: " <> book | [series]] =
      Floki.find(floki_item, "#active-filters li") |> Floki.text() |> String.split(" Series: ")

    %__MODULE__{
      series: String.trim(series),
      book: book,
      teachings_urls: [],
      teachings: []
    }
  end

  def teaching_urls(body) do
    Floki.find(body, "[data-key]")
    |> Enum.map(fn x ->
      Floki.find(x, "a")
      |> Floki.attribute("href")
      |> Floki.text
    end)
  end
end
