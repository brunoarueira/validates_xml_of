module ValidatesXml
  class Railtie < Rails::Railtie
    initializer 'validates_xml.load_i18n_locales' do |app|
      ValidatesXml::load_i18n_locales
    end
  end
end
