#!/usr/bin/env ruby

require 'trollop'
require 'benchmark'

=begin
  The following gems are also (selectively) required:
    * outdent
    * unindent
    * identation
=end

def bench(title='', iter=1, &blk)
  Benchmark.bm(title.size) do |x|
    x.report(title) do
      iter.times { blk.call }
    end
  end
end

if $0 == __FILE__
require File.expand_path('../../lib/heredoc_unindent', __FILE__)
  opts = Trollop::options do
  banner <<-EOS.unindent #gsub(/^\s{4}/, '')
    Unindenting implementations:

      1. heredoc_unindent/unindent
      2. outdent/outdent
      3. unindent/unindent
      4. identation/reset_indentation

  EOS
    opt :imp, "implementation index", :default => 1
    opt :iter, "number of iterations", :default => 1
    opt :file, "file from which the string to be unindented will be read", :type => String
  end
  Trollop::die :file, "must be specified" unless opts.file
  Trollop::die :file, "must exist and be readable" unless File.exist?(opts.file) && File.readable?(opts.file)
  Trollop::die :imp, "must be from 1 to 4" unless (1..4).include? opts.imp

  s = File.read(opts.file)

  case opts.imp
  when 1
    require File.expand_path('../../lib/heredoc_unindent', __FILE__)
    bench('heredoc_unindent/unindent', opts.iter) { s.unindent(false) }
  when 2
    require 'outdent'
    bench('outdent/outdent', opts.iter) { s.outdent }
  when 3
    require 'unindent'
    bench('unindent/unindent', opts.iter) { s.unindent }
  when 4
    require 'indentation'
    bench('identation/reset_indentation', opts.iter) { s.reset_indentation }
  else
    raise 'oops!'
  end
end
