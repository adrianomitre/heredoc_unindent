# This module, which is included in String, define the heredoc unindentation method
# +heredoc_unindent+ and alias it as +unindent+.
#
module HeredocUnindent

  VERSION = '1.0.0'
 
  # Removes leading whitespace from Ruby heredocs. In fact, it removes leading
  # whitespace from each line of a string, but only as much as the first line.
  # 
  # === USAGE:
  # 
  #   if true
  #     puts <<-EOS.unindent
  #       How wonderful it is
  #         to be able
  #       to unindent heredocs
  #     EOS
  #   end
  # 
  # produces
  # 
  #   How wonderful it is
  #     to be able
  #   to unindent heredocs
  # 
  # instead of
  # 
  #         How wonderful it is
  #           to be able
  #         to unindent heredocs 
  #
  def heredoc_unindent
    first_margin = self[/^\s*/].size
    min_margin = self.scan(/^\s*/).map(&:size).min
    if first_margin != min_margin
      puts "warning: first margin != minimum margin, maybe unident"
    end
    margin = first_margin
    re = Regexp.new('^\s{0,' + margin.to_s + '}'  ) # omitting the lower limit produces warnings and wrong behavior in ruby-1.8.7-p330 and ree-1.8.7-2010.02
    self.gsub(re, '')
  end
  alias unindent heredoc_unindent
  
end

class String # :nodoc:
  include HeredocUnindent
end

