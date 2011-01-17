module HeredocUnindent

  VERSION = '1.0.0'
  
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

class String
  include HeredocUnindent
end

