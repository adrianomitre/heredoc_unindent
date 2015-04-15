require "rubygems"
require "test/unit"
require File.expand_path("../../lib/heredoc_unindent", __FILE__)

class TestHeredocUnindent < Test::Unit::TestCase

  def prep_sing1
    ugly = <<-EOS
      that
    is
      weird
    EOS
    
    pretty  = <<EOS
  that
is
  weird
EOS
    return ugly, pretty
  end
  
  def prep_sing2
    ugly = <<-EOS
      for k in 1 .. 10
        puts k
      end
    EOS
    
    pretty  = <<EOS
for k in 1 .. 10
  puts k
end
EOS
    return ugly, pretty
  end
    
  def prep_sing3
    ugly = <<-EOS
      The first line

      The third line    
    EOS
    
    pretty  = <<EOS
      The first line

      The third line    
EOS
    return ugly, pretty
  end

  def prep_sing4
    ugly = <<-EOS
      The first line
      
      The third line    
    EOS
    
    pretty  = <<EOS
The first line

The third line    
EOS
    return ugly, pretty
  end

  # Test new flags.
  #
  def test_ignore_empty_and_ignore_blank
    ugly = <<-EOS
      foo

        bar

  
      baz
EOS
    pretty_e1b0 = <<EOS
    foo

      bar


    baz
EOS
    pretty_e0b1 = ugly.clone
    pretty_e1b1 = <<EOS
foo

  bar


baz
EOS
    assert_equal pretty_e1b0, ugly.unindent(false, ignore_empty: true, ignore_blank: false)
    assert_equal pretty_e0b1, ugly.unindent(false, ignore_empty: false, ignore_blank: false)
    assert_equal pretty_e1b1, ugly.unindent(false, ignore_empty: true, ignore_blank: true)
  end

  def prep_mult
    ugly = <<-BEGIN + "      <--- middle --->\n" + <<-END
      This is the beginning:
      BEGIN
        And now it is over!
    END
    pretty = <<EOS
This is the beginning:
<--- middle --->
  And now it is over!
EOS
    return ugly, pretty
  end

  def test_unindent
    1.upto(4) do |n|
      m = method "prep_sing#{n}"
      perform_tests(*m.call)
    end
    perform_tests(*prep_mult)
  end

  def perform_tests(ugly, pretty)
    ugly_bak = ugly.dup
    assert_equal pretty, ugly.unindent(false)
    assert_equal pretty, ugly.heredoc_unindent(false)
    assert_equal ugly_bak, ugly, '#unindent should have no side-effects'
    assert_equal pretty, ugly.heredoc_unindent!(false) unless pretty == ugly
    assert_equal pretty, ugly
    assert_equal nil, ugly.heredoc_unindent!(false)
    ugly = ugly_bak.dup
    assert_equal pretty, ugly.unindent!(false) unless pretty == ugly
    assert_equal pretty, ugly
    assert_equal nil, ugly.unindent!(false)
    aux = pretty.unindent(false)
    assert_not_same aux, aux.unindent(false), 'out-of-place method should never return the same object, but a copy'
  end
  
  def test_warning
    ugly, pretty = prep_sing1
    filename = "/tmp/#{rand(2**64)}"
    File.open(filename, "w") do |f|
      $stdout = f
      ugly.unindent(true)
      $stdout = STDOUT
    end
    assert File.exist?(filename), "file should exist"
    assert_equal File.read(filename).chomp, "warning: margin of the first line differs from minimum margin"
    assert_nothing_raised { File.delete(filename) }
  end
  
end
