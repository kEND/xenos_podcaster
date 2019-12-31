defmodule XenosPodcaster.Scraper do
  alias XenosPodcaster.Teachings
  @moduledoc """
  Documentation for the Xenos Teachings Podcast Scraper.

  This module is responsible for getting the series page and the 
  teaching pages for a series via HTTP GET requests.
  """

  @doc """
  Get the teaching series page by URL
  """
  def get_teaching_series(teaching_page_url) do
    case HTTPoison.get(teaching_page_url, [], [follow_redirect: true, max_redirect: 5]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Teachings.populate_series_data(%{body: body, url: teaching_page_url})}
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
        Teachings.populate_teaching_data(%{body: body, url: url, title: title})
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  ####  to be refactored to Teachings module
  # TODO HTML encode text so the feed works see series 346 Husbands & Wives
end
