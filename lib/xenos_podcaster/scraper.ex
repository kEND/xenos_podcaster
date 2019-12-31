defmodule XenosPodcaster.Scraper do
  @moduledoc """
  Documentation for the Xenos Teachings Podcast Scraper.

  This module is responsible for getting the series page and the 
  teaching pages for a series via HTTP GET requests.
  """

  @doc """
  Get the teaching series page by URL
  """
  def get_teaching_series(teaching_page_url \\ "https://www.xenos.org/teachings/?series=245") do
    case HTTPoison.get(teaching_page_url, [], [follow_redirect: true, max_redirect: 5]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, populate_series_data(%{body: body, url: teaching_page_url})}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  @doc """
  Get the teaching pages by URL
  """
  def get_teaching_page({url, title}) do
    case HTTPoison.get(url, [], [follow_redirect: true, max_redirect: 5]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        populate_teaching_data(%{body: body, url: url, title: title})
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  ####  to be refactored to Teachings module
  def series_title(body) do
    body
    |> Floki.find("h1#book-title")
    |> Floki.text()
  end

  def series_author(body) do
    body
    |> Floki.find("#author-name-caption a")
    |> Floki.text()
  end

  def author_image_url(body) do
    body
    |> Floki.find("div#author-photo img")
    |> Floki.attribute("src")
    |> Floki.text()
    |> (&("https://www.xenos.org" <> &1)).()
  end

  def series_subtitle(body) do
    body
    |> Floki.find("div#breadcrumb")
    |> Floki.text()
    |> String.trim()
  end

  def series_date(body) do
    body
    |> Floki.find("span.teaching-title a")
    |> Floki.attribute("title")
    |> List.last()
    |> extract_date()
  end

  def extract_date(datestring) do
    datestring = Regex.run(~r/.*(\d{4}-\d{2}-\d{2}).*/, datestring)
                  |> List.last()

    format_date(datestring)
  end

  def teaching_page_urls(body) do
    body
    |> Floki.find("span.teaching-title a")
    |> Enum.map(fn({_name, [{"href", href}, {"title", title}], _}) -> {"https://xenos.org" <> href, title} end)
  end

  def populate_series_data(%{body: body, url: url}) do
    %{title: series_title(body), 
      author: series_author(body),
      url: url, 
      image_url: author_image_url(body),
      subtitle: series_subtitle(body),
      last_build_date: series_date(body),
      teachings: Enum.map(teaching_page_urls(body), &get_teaching_page(&1))
    }
  end

  def populate_teaching_data(%{body: body, url: url, title: title}) do
    {date, teaching_id} = date_and_id(title)

    %{author: teaching_author(body),
      medial_url: media_url(body),
      teaching_title: teaching_title(body),
      xenos_teaching_id: teaching_id,
      date: date,
      url: url,
      verse_range: verse_range(body)
    }
  end

  def teaching_author(body) do
    body
    |> Floki.find("#author-name-caption a")
    |> Floki.text()
  end

  def teaching_title(body) do
    body
    |> Floki.find("#teaching-title")
    |> Floki.text()
  end

  def verse_range(body) do
    body
    |> Floki.find("#verse-range")
    |> Floki.text()
  end

  def media_url(body) do
    body
    |> Floki.find("#mp3")
    |> Floki.attribute("href")
    |> Floki.text()
  end

  def date_and_id(title) do
    captures = Regex.named_captures(~r/.*(?<datestring>\d{4}-\d{2}-\d{2}).*\((?<teaching_id>t\d+)\)/, title)

    {format_date(captures["datestring"]), captures["teaching_id"]}
  end

  def format_date(datestring) do
    Timex.format!(Timex.to_datetime(Timex.parse!(datestring, "{YYYY}-{0M}-{0D}"), "America/New_York"), "{RFC822}")
  end
end
