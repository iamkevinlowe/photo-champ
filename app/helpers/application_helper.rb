module ApplicationHelper

  def short_url(url)
    Bitly.client.shorten(url).short_url
  rescue
  end
end
