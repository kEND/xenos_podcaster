defmodule XenosPodcaster.Teachings do
  alias XenosPodcaster.Scraper

  @doc """
  Return a series map with a list of teachings for consumption by the feed
  """
  def series(url \\ "https://www.xenos.org/teachings/?series=245") do
    {:ok, series} = Scraper.get_teaching_series(url)
    series
  end
end
