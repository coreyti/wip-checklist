module Support
  def io
    @io ||= HighLine.new
  end
end
