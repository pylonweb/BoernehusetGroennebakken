require 'refinerycms-base'

module Refinery
  module FAQ

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
          plugin.name = "FAQ"
          plugin.pathname = root
          plugin.url = {:controller => '/admin/faqs', :action => 'index'}
          plugin.menu_match = /^\/?(admin|refinery)\/?(faqs)?/
          plugin.activity = {
            :class => Faq,
            :title => 'question'
          }
        end
      end
    end
  end
end
