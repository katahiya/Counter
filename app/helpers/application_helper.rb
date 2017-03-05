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

  def flash_messages_with_excepted_key(excepted_key=nil)
    render "shared/flash_messages", excepted_key: excepted_key
  end
end
