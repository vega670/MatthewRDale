require 'test_helper'

class FeedsCellTest < Cell::TestCase
  test "project_updates" do
    invoke :project_updates
    assert_select "p"
  end
  
  test "games" do
    invoke :games
    assert_select "p"
  end
  
  test "music" do
    invoke :music
    assert_select "p"
  end
  

end
