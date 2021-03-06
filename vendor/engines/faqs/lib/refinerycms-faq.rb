require 'refinerycms-base'

module Refinery
  module Faqs

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_faq"
          plugin.pathname = root
          plugin.url = {:controller => '/admin/faqs', :action => 'index'}
          plugin.menu_match = /(refinery|admin)\/faqs/
          plugin.activity = {
            :class => Faq,
            :title => 'question'
          }
        end
      end
    end
  end
end
