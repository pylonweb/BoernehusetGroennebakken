module NavigationHelpers
  module Refinery
    module Faqs
      def path_to(page_name)
        case page_name
        when /the list of faqs/
          admin_faqs_path

         when /the new faq form/
          new_admin_faq_path
        else
          nil
        end
      end
    end
  end
end
