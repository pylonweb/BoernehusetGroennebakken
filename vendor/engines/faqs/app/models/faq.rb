class Faq < ActiveRecord::Base

  acts_as_indexed :fields => [:question, :answer]

  validates :question, :presence => true, :uniqueness => true
  
end
