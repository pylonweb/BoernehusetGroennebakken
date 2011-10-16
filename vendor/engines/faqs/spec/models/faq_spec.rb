require 'spec_helper'

describe Faq do

  def reset_faq(options = {})
    @valid_attributes = {
      :id => 1,
      :question => "RSpec is great for testing too"
    }

    @faq.destroy! if @faq
    @faq = Faq.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_faq
  end

  context "validations" do
    
    it "rejects empty question" do
      Faq.new(@valid_attributes.merge(:question => "")).should_not be_valid
    end

    it "rejects non unique question" do
      # as one gets created before each spec by reset_faq
      Faq.new(@valid_attributes).should_not be_valid
    end
    
  end

end