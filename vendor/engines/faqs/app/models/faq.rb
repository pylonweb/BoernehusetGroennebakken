class Faq < ActiveRecord::Base

  acts_as_indexed :fields => [:question, :answer]

  validates :question, :uniqueness => true
  validates :question, :answer, :presence => true
end
