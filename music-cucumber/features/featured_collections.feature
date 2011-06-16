Feature: Featured collections
  As an API client
  In order to do things with featured collections
  I want to test CRUD for featured collections
  
  Background:
    Given I send and accept JSON
    And a user exists
  
  Scenario: View featured collections when there are no featured collections
    When I send a GET request for "/collections/featured"
    Then the response status should be "200"
    And the JSON response should have 0 "$.collections.*"
    
    Scenario: View featured collections when there are some featured collections
      When I send a GET request for "/collections/featured"
      Then the response status should be "200"
      And the JSON response should have 0 "$.collections.*"

    Scenario: View unfeatured collections when there are some featured collections
      When I send a GET request for "/collections/featured?featured=0"
      Then the response status should be "200"
      And the JSON response should have 0 "$.collections.*"
