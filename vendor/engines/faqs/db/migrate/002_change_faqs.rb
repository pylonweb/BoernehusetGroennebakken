class ChangeFaqs < ActiveRecord::Migration
  def self.up
  	change_table :faqs do |t|
	  t.remove :answer
	  t.text :answer
	end
  end

  def self.down
  	change_table :faqs do |t|
	  	t.remove :answer
	    t.string :answer
	end
  end
end