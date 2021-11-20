defmodule XenosPodcaster.SeriesData do
  defstruct [
    :series,
    :book,
    teachings_urls: [],
    teachings: []
  ]

  def populate(floki_item) do
    ["Book: " <> book | [series]] = Floki.find(floki_item, "#active-filters li") |> Floki.text() |> String.split(" Series: ")

    %__MODULE__{
      series: String.trim(series),
      book: book,
      teachings_urls: [],
      teachings: []
    }
  end
end
