module CustomSourcesHelper
  def custom_source_class_name(source)
    source.class.name.demodulize.downcase
  end

  def custom_source_form(source)
    source_class = custom_source_class_name(source)
    if source.persisted? 
      form_tag(update_custom_source_path(type: source_class, id: source.to_param), html: {class: 'form-horizontal'}, method: :put)
    else
      form_tag(create_custom_source_path(type: source_class), html: {class: 'form-horizontal'}, method: :post)
    end
  end
end