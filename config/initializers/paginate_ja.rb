# will_paginateで出力されるページネーションの日本語化
WillPaginate::ViewHelpers.pagination_options = {
  :class          => 'pagination',
  :previous_label => '&laquo;前へ',
  :next_label     => '次へ&raquo;',
  :inner_window   => 4, # links around the current page
  :outer_window   => 1, # links around beginning and end
  :separator      => ' ', # single space is friendly to spiders and non-graphic browsers
  :param_name     => :page,
  :params         => nil,
  :renderer       => 'WillPaginate::ViewHelpers::LinkRenderer',
  :page_links     => true,
  :container      => true
}

# エントリー情報を日本語化
module WillPaginate::ViewHelpers::Base
  def page_entries_info(collection, options = {})
    entry_name = options[:entry_name] || (collection.empty?? 'entry' :
                 collection.first.class.name.underscore.gsub('_', ' '))

    plural_name = if options[:plural_name]
      options[:plural_name]
    elsif entry_name == 'entry'
      plural_name = 'entries'
    elsif entry_name.respond_to? :pluralize
      plural_name = entry_name.pluralize
    else
      entry_name + 's'
    end

    unless options[:html] == false
      b  = '<b>'
      eb = '</b>'
      sp = ' '
    else
      b  = eb = ''
      sp = ' '
    end

    if collection.total_pages < 2
      case collection.size
      when 0; "#{plural_name}は見つかりませんでした。"
      when 1; "#{b}1#{eb} 件の#{entry_name}が見つかりました。"
      else;   "#{b}#{collection.size}#{eb} 件の#{plural_name}を表示しています。"
      end
    else
      %{#{b}%d#{eb} 件中 #{b}%d#{sp}-#{sp}%d#{eb} 番目までの#{plural_name}を表示しています。} % [
        collection.total_entries,
        collection.offset + 1,
        collection.offset + collection.length,
      ]
    end
  end
end
