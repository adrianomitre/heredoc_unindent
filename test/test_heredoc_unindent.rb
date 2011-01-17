require "test/unit"
require File.join(File.dirname(File.expand_path(__FILE__)), "../lib/heredoc_unindent")

class TestHeredocUnindent < Test::Unit::TestCase

  def test_unindent_single_heredocs
    foo = <<-EOS
      for k in 1 .. 10
        puts k
      end
    EOS
    
    bar = <<EOS
for k in 1 .. 10
  puts k
end
EOS
    assert_equal bar, foo.unindent    
  end
  
  def test_unindent_multiple_heredocs
    foo = <<-BEGIN + "<--- middle --->\n" + <<-END
      This is the beginning:
      BEGIN
        And now it is over!
    END
    bar = <<-EOS
This is the beginning:
<--- middle --->
  And now it is over!
    EOS
    assert_equal bar, foo.unindent    
  end
  
end
