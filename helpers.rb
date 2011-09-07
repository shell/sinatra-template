helpers do
  def link_to url, title=nil, &block
    "<a href='#{url}'>#{title || yield}<a>"
  end

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['frank', 'sinatra']
  end

  def in_groups_of(number, fill_with = nil)
    if fill_with == false
      collection = self
    else
      # size % number gives how many extra we have;
      # subtracting from number gives how many to add;
      # modulo number ensures we don't add group of just fill.
      padding = (number - size % number) % number
      collection = dup.concat([fill_with] * padding)
    end

    if block_given?
      collection.each_slice(number) { |slice| yield(slice) }
    else
      returning [] do |groups|
        collection.each_slice(number) { |group| groups << group }
      end
    end
  end

  def options_for_select(container, selected = nil)
    return container if String === container

    container = container.to_a if Hash === container
    selected, disabled = extract_selected_and_disabled(selected).map do | r |
       Array.wrap(r).map { |item| item.to_s }
    end

    container.map do |element|
      html_attributes = option_html_attributes(element)
      text, value = option_text_and_value(element).map { |item| item.to_s }
      selected_attribute = ' selected="selected"' if option_value_selected?(value, selected)
      disabled_attribute = ' disabled="disabled"' if disabled && option_value_selected?(value, disabled)
      %(<option value="#{html_escape(value)}"#{selected_attribute}#{disabled_attribute}#{html_attributes}>#{html_escape(text)}</option>)
    end.join("\n")

  end

  def extract_selected_and_disabled(selected)
    if selected.is_a?(Proc)
      [ selected, nil ]
    else
      selected = Array.wrap(selected)
      options = selected.extract_options!.symbolize_keys
      [ options.include?(:selected) ? options[:selected] : selected, options[:disabled] ]
    end
  end

  def option_html_attributes(element)
    return "" unless Array === element
    html_attributes = []
    element.select { |e| Hash === e }.reduce({}, :merge).each do |k, v|
      html_attributes << " #{k}=\"#{ERB::Util.html_escape(v.to_s)}\""
    end
    html_attributes.join
  end

  def option_text_and_value(option)
    # Options are [text, value] pairs or strings used for both.
    case
    when Array === option
      option = option.reject { |e| Hash === e }
      [option.first, option.last]
    when !option.is_a?(String) && option.respond_to?(:first) && option.respond_to?(:last)
      [option.first, option.last]
    else
      [option, option]
    end
  end

  def option_value_selected?(value, selected)
    if selected.respond_to?(:include?) && !selected.is_a?(String)
      selected.include? value
    else
      value == selected
    end
  end

end