class JpmobileGenerator < Rails::Generator::NamedBase

  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    record do |m|
      model_names = ['jpmobile_carrier', 'jpmobile_device', 'jpmobile_ipaddress']
      
      model_names.each do | model_name |
        m.template "#{model_name}_model.rb", File.join('app/models', class_path, "#{model_name}.rb")
      end
      
      m.migration_template 'migration.rb', 'db/migrate',
                           :migration_file_name => "create_jpmobile_tables"
    end
  end
  
end
