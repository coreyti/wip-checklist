module Support
  def show(message, io = :stdout)
    output(/#{Regexp.escape(message.strip_heredoc)}/).send(:"to_#{io}")
  end
end
