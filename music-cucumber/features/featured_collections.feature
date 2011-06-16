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
  
  Scenario: Update featured collections
    When I send a PUT request to "/collections/featured" with the following:
      """
      {
          "collections": [
            { "username": "testuser" }
          ]
      }
      """
    Then the response status should be "200"
    And the JSON response should have 1 "$.collections.*"
    And the JSON response should have "$.collections.featured_position" with the text "0"
    When I send a GET request for "/collections/featured"
    Then the response status should be "200"
    And the JSON response should have 1 "$.collections.*"
    
    Scenario: View featured collections when there are some featured collections
      When I send a GET request for "/collections/featured"
      Then the response status should be "200"
      And the JSON response should have 0 "$.collections.*"

    Scenario: View unfeatured collections when there are some featured collections
      When I send a GET request for "/collections/featured?featured=0"
      Then the response status should be "200"
      And the JSON response should have 0 "$.collections.*"
