# This module, which is included in String, define the heredoc unindentation method
# +heredoc_unindent+ and alias it as +unindent+.
#
module HeredocUnindent

  VERSION = '1.0.0'
 
  # Removes common margin from indented strings such as the ones produced by
  # heredocs, i.e., strips out leading whitespace chars at the beggining of
  # each line (but only as much as the line with the smallest margin).
  #
  # Unless the optional argument +warn_first_dif_min+ is set to false or nil, a
  # warning is produced when the margin of the first line differs from the minimum.
  #
  def heredoc_unindent(warn_first_dif_min=true)
    min_margin = self.scan(/^\s*/).map(&:size).min
    if warn_first_dif_min
      first_margin = self[/^\s*/].size
      if first_margin != min_margin
        puts "warning: margin of the first line differs from minimum margin"
      end
    end
    re = Regexp.new('^\s{0,' + min_margin.to_s + '}'  ) # omitting the lower limit produces warnings and wrong behavior in ruby-1.8.7-p330 and ree-1.8.7-2010.02
    self.gsub(re, '')
  end
  alias unindent heredoc_unindent

  # Performs HeredocUnindent#heredoc_unindent in place, returning self, or nil if no changes were made
  #
  def  heredoc_unindent!(warn_first_dif_min=true)
    orig = self.dup
    self.replace(self.heredoc_unindent(warn_first_dif_min))
    self != orig ? self : nil
  end
  alias unindent! heredoc_unindent!
  
end

class String # :nodoc:
  include HeredocUnindent
end

