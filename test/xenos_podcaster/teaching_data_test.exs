defmodule XenosPodcaster.TeachingDataTest do
  use ExUnit.Case

  alias XenosPodcaster.TeachingData

  describe "" do
    test "" do
      floki_teaching_summary_item =
        {"div", [{"data-key", "3049"}],
         [
           {"a", [{"href", "/teaching/3049"}],
            [
              {"div", [{"class", "teaching-item grid-x grid-margin-x"}],
               [
                 {:comment, " <div class=\"teaching-item grid-x\"> "},
                 {:comment, " <div class=\"teaching-item grid-y\"> "},
                 {:comment,
                  " <div class=\"teaching-title cell medium-4 show-for-medium\">Introduction</div> "},
                 {:comment,
                  " <div class=\"teaching-title-abbr cell small-5 hide-for-medium\">Introduction</div> "},
                 {:comment,
                  " <div class=\"teaching-title cell medium-auto show-for-medium\">Introduction</div> "},
                 {:comment,
                  " <div class=\"teaching-title-abbr cell medium-auto hide-for-medium\">Introduction</div> "},
                 {"div", [{"class", "teaching-title cell medium-auto hide-for-medium-only"}],
                  ["Introduction"]},
                 {"div", [{"class", "teaching-title-abbr cell medium-auto show-for-medium-only"}],
                  ["Introduction"]},
                 {"div", [{"class", "author cell medium-auto"}], ["Dennis McCallum"]},
                 {:comment,
                  " <div class=\"passage cell medium-auto show-for-large\">Hebrews&nbsp;1:1-2:3</div> "},
                 {:comment,
                  " <div class=\"passage-abbr cell medium-auto hide-for-large\">Heb&nbsp;1:1-2:3</div> "},
                 {"div", [{"class", "passage cell medium-auto hide-for-medium-only"}],
                  ["Hebrews 1:1-2:3"]},
                 {"div", [{"class", "passage-abbr cell medium-auto show-for-medium-only"}],
                  ["Heb 1:1-2:3"]},
                 {:comment, " <div class=\"year cell medium-auto show-for-large\">2015</div> "},
                 {:comment, " <div class=\"year cell large-1 show-for-large\">2015</div> "},
                 {"div", [{"class", "year cell medium-auto hide-for-medium-only"}], ["2015"]}
               ]}
            ]}
         ]}

      expected_teaching_data = %TeachingData{
        author: "Dennis McCallum",
        url: "/teaching/3049",
        verse_range: "Hebrews 1:1-2:3"
      }

      assert TeachingData.populate(floki_teaching_summary_item) == expected_teaching_data
    end
  end
end
