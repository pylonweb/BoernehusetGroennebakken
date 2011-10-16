@faqs
Feature: Faqs
  In order to have faqs on my website
  As an administrator
  I want to manage faqs

  Background:
    Given I am a logged in refinery user
    And I have no faqs

  @faqs-list @list
  Scenario: Faqs List
   Given I have faqs titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of faqs
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @faqs-valid @valid
  Scenario: Create Valid Faq
    When I go to the list of faqs
    And I follow "Add New Faq"
    And I fill in "Question" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 faq

  @faqs-invalid @invalid
  Scenario: Create Invalid Faq (without question)
    When I go to the list of faqs
    And I follow "Add New Faq"
    And I press "Save"
    Then I should see "Question can't be blank"
    And I should have 0 faqs

  @faqs-edit @edit
  Scenario: Edit Existing Faq
    Given I have faqs titled "A question"
    When I go to the list of faqs
    And I follow "Edit this faq" within ".actions"
    Then I fill in "Question" with "A different question"
    And I press "Save"
    Then I should see "'A different question' was successfully updated."
    And I should be on the list of faqs
    And I should not see "A question"

  @faqs-duplicate @duplicate
  Scenario: Create Duplicate Faq
    Given I only have faqs titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of faqs
    And I follow "Add New Faq"
    And I fill in "Question" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 faqs

  @faqs-delete @delete
  Scenario: Delete Faq
    Given I only have faqs titled UniqueTitleOne
    When I go to the list of faqs
    And I follow "Remove this faq forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 faqs
 