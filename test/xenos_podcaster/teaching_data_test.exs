defmodule XenosPodcaster.TeachingDataTest do
  use ExUnit.Case

  alias XenosPodcaster.TeachingData

  describe "" do
    test "" do
      {:ok, body_from_file} = File.read("test/support/3049.html")

      expected_teaching_data = %TeachingData{
        author: "Dennis McCallum",
        date: "01/08/2015",
        image_url: "./3049_files/DennisMcCallum_200x200.jpg",
        media_url: "https://media.dwellcc.org/teachings/heb/dennis/2015/heb1-1.m4a",
        teaching_title: "Introduction",
        url: "stubbed url",
        verse_range: "Hebrews 1:1-2:3",
        xenos_teaching_id: nil
      }

      assert TeachingData.populate({:ok, body_from_file}) == expected_teaching_data
    end
  end
end
