class FaqsController < ApplicationController

  before_filter :find_all_faqs
  before_filter :find_page

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @faq in the line below:
    error_404
  end

protected

  def find_all_faqs
    @faqs = Faq.order('position ASC')
  end

  def find_page
    @page = Page.where(:link_url => "/faqs").first
  end

end
