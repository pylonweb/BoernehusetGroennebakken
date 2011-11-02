class FaqsController < ApplicationController

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @faq in the line below:
    error_404
  end
end