class CustomSourceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  
  def copy_custom_source_file
    template "custom_source.erb", "app/models/custom_sources/#{file_name}.rb"
    template "_form.html.erb", "app/views/custom_sources/#{file_name}/_form.html.erb"
  end
end
