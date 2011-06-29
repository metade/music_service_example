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
            { "url_key": "abcd" }
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

  Scenario: Update an individual collections's featured position
    Given a collection exists
    When I send a PUT request to "/collections/@collection_id" with the following:
      """
      {
          "collection": {
              "featured_position": 0,
              "status": 1
          }
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.collection.featured_position" with the text "0"
    When I send a GET request for "/collections/featured"
    Then the response status should be "200"
    And the JSON response should have 1 "$.collections.*"
	
  Scenario: Update an individual collections's featured position with null
    Given a collection exists
    When I send a PUT request to "/collections/@collection_id" with the following:
      """
      {
          "collection": {
              "featured_position": null
          }
      }
      """
      Then the response status should be "200"
      And the JSON response should have "$.collection.featured_position" as nil
      When I send a GET request for "/collections/featured"
      Then the response status should be "200"
      And the JSON response should have 0 "$.collections.*"

  Scenario: Update an individual collections's medium synopsis with null
    Given a collection exists
    When I send a PUT request to "/collections/@collection_id" with the following:
      """
      {
          "collection": {
              "medium_synopsis": null
          }
      }
      """
      Then the response status should be "200"
      And the JSON response should have "$.collection.medium_synopsis" as nil
      When I send a GET request for "/collections/featured"
      Then the response status should be "200"
      And the JSON response should have 0 "$.collections.*"