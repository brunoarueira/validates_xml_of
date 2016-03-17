module ValidatesXmlOf
  class Railtie < Rails::Railtie
    initializer 'validates_xml_of.load_i18n_locales' do |app|
      ValidatesXmlOf::load_i18n_locales
    end
  end
end
