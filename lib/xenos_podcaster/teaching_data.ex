defmodule XenosPodcaster.TeachingData do
  defstruct [
    :author,
    :url,
    :verse_range
  ]

  def populate(floki_item) do
    %__MODULE__{
      author: Floki.find(floki_item, ".author") |> Floki.text,
      url: Floki.find(floki_item, "a") |> Floki.attribute("href") |> Floki.text(),
      verse_range: Floki.find(floki_item, ".passage") |> Floki.text()
    }
  end

end
