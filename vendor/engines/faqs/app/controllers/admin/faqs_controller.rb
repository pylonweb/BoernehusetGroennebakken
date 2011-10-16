module Admin
  class FaqsController < Admin::BaseController

    crudify :faq,
            :title_attribute => 'question', :xhr_paging => true

  end
end
