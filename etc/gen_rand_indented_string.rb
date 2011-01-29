#!/usr/bin/env ruby

require File.expand_path('../../lib/heredoc_unindent', __FILE__)

def rand_chars(n)
  'x' * n
end

alias orig_rand rand
def rand(min, max)
  orig_rand(max-min+1)+min
end

if $0 == __FILE__
  require 'trollop'
  require 'benchmark'

  opts = Trollop::options do
    banner <<-EOS.unindent
    Generates a random unindented string.
      
    EOS
    opt :width, "line width", :default => 80
    opt :lines, "number_of_lines", :default => 1024
    opt :min, "minimum margin", :default => 2
    opt :max, "maximum margin", :default => 2*8
  end
  Trollop::die :min, 'must be >= 0' unless opts[:min] >= 0
  Trollop::die :max, "must be <= #{opts.width} (width)" unless opts[:max] < opts.width
  
  # 132 x 43
  # 80 x 24
  result = ''
  n = opts.width

  opts.lines.times do
    m = [rand(opts[:min], opts[:max]), n].min
    result << ' '*m + rand_chars(rand(1,n-m-1)) + "\n"
  end

  puts result
end
