module ApplicationHelper

  #return full title for pages
  def full_title(page_title = '')
    base_title = "Counter"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
