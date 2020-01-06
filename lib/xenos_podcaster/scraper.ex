defmodule XenosPodcaster.Scraper do
  @moduledoc """
  Documentation for the Xenos Teachings Podcast Scraper.

  This module is responsible for getting the series page and the 
  teaching pages for a series via HTTP GET requests.
  """

  @doc """
  Get the teaching series page by URL
  """
  def get_teaching_series(series_no) do
    case HTTPoison.get("https://www.xenos.org/teachings/?series=" <> series_no, [], [follow_redirect: true, max_redirect: 5]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, %{body: body}}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  @doc """
  Get the teaching pages by URL
  """
  def get_teaching_page(url) do
    case HTTPoison.get(url, [], [follow_redirect: true, max_redirect: 5]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, %{body: body}}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  ####  to be refactored to Teachings module
  # TODO HTML encode text so the feed works see series 346 Husbands & Wives
end
