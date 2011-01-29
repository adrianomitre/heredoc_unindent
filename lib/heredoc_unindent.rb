module CoreExt
  module String

    # This module, which is automatically included in ::String, define in-place
    # and out-of-place unindentation methods.
    #
    module HeredocUnindent
     
      private
      
      # Actual implementations of the unindentation mechanism,
      # both for in and out-of-place processing.
      #
      # @note The only reason there are two implementations is because the new
      #       one is slower than the old one on MRI and REE 1.8.7. The fastest
      #       implementation is automatically chosen based on the virtual
      #       machine being executed.
      #
      # @param [Boolean] warn_first_not_min 
      # @param [Boolean] in_place
      # @return [String, nil]
      #
      
      # about 50% faster in jruby, 56% in ruby-1.9.2, 62% in rbx-1.2.0 (new vs old)
      #
      def unindent_base_new(in_place, warn_first_not_min)
        m_first = nil
        m_min = nil
        self.scan(/^[ \t]*/) do |m|
          ms = m.size
          m_first ||= ms
          m_min = ms if !m_min || ms < m_min
          # break if ms == 0 ## only worth if the probability of marginless line above certain threshold
        end
        if m_first != m_min && warn_first_not_min
          puts "warning: margin of the first line differs from minimum margin"
        end
        return in_place ? nil : self.dup unless m_min > 0
        re = Regexp.new('^\s{' + m_min.to_s + '}'  )
        in_place ? gsub!(re, '') : gsub(re, '')
      end
      
      # about 10% faster in ree, 20% in ruby-1.8.7 (old vs new)
      #
      def unindent_base_old(in_place, warn_first_not_min)
        margins = self.scan(/^[ \t]*/).map(&:size)
        margins_min = margins.min
        if margins.first != margins_min && warn_first_not_min
          puts "warning: margin of the first line differs from minimum margin"
        end
        return in_place ? nil : self.dup unless margins_min != 0
        re = Regexp.new('^\s{' + margins_min.to_s + '}'  )
        in_place ? gsub!(re, '') : gsub(re, '')
      end

      if RUBY_VERSION >= '1.9' || defined?(RUBY_DESCRIPTION) && RUBY_DESCRIPTION =~ /jruby|rubinius/i
        alias unindent_base unindent_base_new
      else
        alias unindent_base unindent_base_old
      end
      
      public
    
      # Removes common margin from indented strings, such as the ones produced
      # by indented heredocs. In other words, it strips out leading whitespace
      # chars at the beggining of each line, but only as much as the line with
      # the smallest margin.
      #
      # Unless the optional argument +warn_first_dif_min+ is set to +false+ (or
      # +nil+), a warning is produced when the margin of the first line differs
      # from the minimum.
      #
      # @example
      #
      #   if true
      #     s = <<-EOS
      #       How sad it is to be unable to unindent heredocs
      #     EOS
      #     t = <<-EOS.unindent
      #       How wonderful it is to be able to do it!
      #     EOS
      #   end
      #  
      #   s[0..12]  #=>  "      How sad"
      #   t[0..12]  #=>  "How wonderful"
      #
      # @param  [Boolean] warn_first_not_min toggle warning if the margin of the first line differs from minimum margin
      # @return [::String] unindented string
      #
      def heredoc_unindent(warn_first_not_min=true)
        unindent_base(false, warn_first_not_min)
      end
      alias unindent heredoc_unindent

      # Same as #heredoc_unindent, but works in-place. Returns self, or nil if
      # no changes were made
      #
      # @note Avoid attributing the return value of this method because it
      #       may be nil (see Example 2).
      #
      # @example 1 Recommended
      #
      #   s = "   foo"  #=> "   foo"
      #   s.unindent!   #=>  "foo"
      #   s.unindent!   #=>  nil
      #
      # @example 2 Disencouraged
      #   
      #   s = <<-EOS.unindent!
      #     the result would be as intended
      #   if this line weren't unindented
      #   EOS
      #   s  #=>  nil
      #
      # @param  [Boolean] warn_first_dif_min toggle warning if the margin of the first line differs from minimum margin
      # @return [::String, NilClass] unindented self, or nil if no changes were made
      #
      def  heredoc_unindent!(warn_first_not_min=true)
        unindent_base(true, warn_first_not_min)
      end
      alias unindent! heredoc_unindent!
    end
    
    ::String.class_eval { include ::CoreExt::String::HeredocUnindent }
  end
end
