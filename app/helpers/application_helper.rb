module ApplicationHelper
  def markdown(text)
    sanitize(BlueCloth.new(text).to_html)
  end
end
