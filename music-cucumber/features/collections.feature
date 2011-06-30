Feature: Collections
  As an API client
  In order to do things with collections
  I want to test CRUD for collections
  
  Background:
    Given I send and accept JSON
    And a user exists
  
  Scenario: List collections when there are no collections
    When I send a GET request for "/collections"
    Then the response status should be "200"
    And the JSON response should have 0 "$.collections"
  
  Scenario: Create a collection
    When I send a POST request to "/users/testuser/collections" with the following:
      """
      {
          "collection": {
              "title": "Test Collection"
          }
      }
      """
    Then the response status should be "201"
    And show me the response
    And the JSON response should have the following:
      | jsonpath                  | value                        |
      | $.collection.title        | Test Collection              |
    
  Scenario: View a collection
    Given a collection exists
    When I send a GET request for "/collections/:url_key"
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath                   | value                      |
      | $.collection.title         | Test Collection            |
  
  Scenario: Update a collection
    Given a collection exists
    When I send a PUT request to "/collections/:url_key" with the following:
      """
      {
          "collection": {
              "medium_synopsis": "A fantastic medium collections synopsis",
              "short_synopsis": "A fantastic short collections synopsis",
              "title": "Fantastic Collections",
              "artists": "Fantastic",
              "has_image": 1,
              "use_pips": 1,
              "url": "http://test",
              "promoted_at": "2011-05-25T12:31:25+0100"
          }
      }
      """
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath                     | value                                   |
      | $.collection.title           | Fantastic Collections                   |
      | $.collection.short_synopsis  | A fantastic short collections synopsis  |
      | $.collection.medium_synopsis | A fantastic medium collections synopsis |
      | $.collection.artists         | Fantastic                               |
      | $.collection.has_image       | 1                                       |
      | $.collection.use_pips        | 1                                       |
      | $.collection.url             | http://test                             |
      | $.collection.promoted_at     | 2011-05-25T11:31:25Z                    |
  
  @current
  Scenario: Update a collection's owner
    Given a collection exists
    And a music guide called "Zane Lowe" exists
    When I send a PUT request to "/collections/:url_key" with the following:
      """
      {
          "collection": {
              "user": {
                "username": "zanelowe"
              }
          }
      }
      """
    Then the response status should be "200"
    And show me the response
    And the JSON response should have the following:
      | jsonpath                      | value     |
      | $.collection.user.username    | zanelowe  |
      | $.collection.user.name        | Zane Lowe |
      
  Scenario: Delete a collection
    Given a collection exists
    When I send a DELETE request to "/collections/:url_key"
    Then the response status should be "200"
    And the response should be empty
  And there should be 0 collections

  # Scenario: List published collections
  # 
  # Scenario: List collections ordered by created_at
  # 
  # Scenario: List collections ordered by updated_at
  # 
  # Scenario: List collections ordered by expired date ascending
  # 
  # Scenario: List collections ordered by expired date descending