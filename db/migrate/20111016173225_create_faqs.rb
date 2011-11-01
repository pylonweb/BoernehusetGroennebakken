class CreateFaqs < ActiveRecord::Migration

  def self.up
    create_table :faqs do |t|
      t.string :question
      t.string :answer
      t.integer :position

      t.timestamps
    end

    add_index :faqs, :id

    load(Rails.root.join('db', 'seeds', 'faqs.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "faqs"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/faqs"})
    end

    drop_table :faqs
  end

end
