Feature: Collection Clips
  As an API client
  In order to do things with collection clips
  I want to test CRUD for collection clips
  
  Background:
    Given I send and accept JSON
    And a user exists
    And a collection exists
  
  Scenario: List collection clips when there are no clips for the collection
    When I send a GET request for "/collections/@collection_id/clips"
    Then the response status should be "200"
    And show me the response
    And the JSON response should have 0 "$.clips"

  Scenario: Create a collection clip
    When I send a POST request to "/collections/@collection_id/clips" with the following:
      """
      {
          "clip": {
              "title": "Test Clip",
              "pid"  : "testpid"
          }
      }
      """
    Then the response status should be "200"
    And show me the response
    And the JSON response should have the following:
      | jsonpath                  | value                        |
      | $.clip.title              | Test Clip                    |
    And there should be 1 clip
  
  @current
  Scenario: Add the same clip to 2 collections
    When I send a POST request to "/collections/@collection_id/clips" with the following:
      """
      {
          "clip": {
              "title": "Test Clip",
              "pid"  : "testpid"
          }
      }
      """
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath                  | value                        |
      | $.clip.title              | Test Clip                    |
    And there should be 1 clip
    Given a collection exists
    When I send a POST request to "/collections/@collection_id/clips" with the following:
      """
      {
          "clip": {
              "title": "Test Clip",
              "pid"  : "testpid"
          }
      }
      """
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath                  | value                        |
      | $.clip.title              | Test Clip                    |
    And there should be 1 clip
    
  Scenario: Update a collection clip
    Given a clip exists
    When I send a PUT request to "/collections/@collection_id/clips/@clip_pid" with the following:
      """
      {
          "clip": {
              "title": "Test Clip Updated"
          }
      }
      """
      Then the response status should be "200"
      And show me the response
      And the JSON response should have the following:
      | jsonpath                  | value                        |
      | $.clip.title              | Test Clip Updated            |
  
  Scenario: Delete a collection clip
    Given a clip exists
    When I send a DELETE request to "/collections/@collection_id/clips/@clip_pid"
    Then show me the response
    Then the response status should be "200"
    And the response should be empty
    And there should be 0 clips
  