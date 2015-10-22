module Support
  def show(expected, io = :stdout)
    ShowMatcher.new(expected.strip_heredoc).send(:"to_#{io}")
  end

  class ShowMatcher < RSpec::Matchers::BuiltIn::Output
    def matches?(block)
      @block = block
      return false unless Proc === block
      @actual = @stream_capturer.capture(block)
      values_match?(/#{Regexp.escape(@expected)}/, @actual)
    end

    def description
      "show the desired content to #{@stream_capturer.name}"
    end

    def failure_message
      "expected block to #{description}"
    end
  end
end
