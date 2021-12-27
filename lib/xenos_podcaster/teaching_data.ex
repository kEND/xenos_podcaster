defmodule XenosPodcaster.TeachingData do
  defstruct [
    :author,
    :url,
    :image_url,
    :media_url,
    :teaching_title,
    :date,
    :verse_range
  ]

  def populate({:ok, floki_item}) do
    %__MODULE__{
      author: author(floki_item),
      image_url: image_url(floki_item),
      date: date(floki_item),
      url: url(floki_item),
      media_url: media_url(floki_item),
      teaching_title: teaching_title(floki_item),
      verse_range: verse_range(floki_item)
    }
  end

  def populate(body) do
    Floki.parse_document(body)
    |> populate()
  end

  def author(floki_item) do
    Floki.find(floki_item, ".author-name") |> Floki.text() |> String.trim()
  end

  def url(_floki_item), do: "stubbed url"
  def verse_range(floki_item), do: Floki.find(floki_item, ".passage") |> Floki.text()

  def media_url(floki_item) do
    floki_item
    |> Floki.find("#download ul li:first-child a")
    |> Floki.attribute("href")
    |> Floki.text()
    |> String.split("?", parts: 2)
    |> hd()
  end

  def teaching_title(floki_item), do: Floki.find(floki_item, ".teaching-title") |> Floki.text()

  def date(floki_item) do
    "Teaching date: " <> date =
      floki_item
      |> Floki.find(".teaching-date")
      |> Floki.text()
      |> String.trim()

    date
  end

  def image_url(floki_item) do
    floki_item
    |> Floki.find(".author-photo img")
    |> Floki.attribute("src")
    |> Floki.text()
  end
end
