Given /^I have no faqs$/ do
  Faq.delete_all
end

Given /^I (only )?have faqs titled "?([^\"]*)"?$/ do |only, titles|
  Faq.delete_all if only
  titles.split(', ').each do |title|
    Faq.create(:question => title)
  end
end

Then /^I should have ([0-9]+) faqs?$/ do |count|
  Faq.count.should == count.to_i
end
