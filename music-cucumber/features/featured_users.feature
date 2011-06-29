Feature: Users
  As an API client
  In order to do things with featured users
  I want to test CRUD for featured users
  
  Background:
    Given I send and accept JSON
    And a user exists
  
  Scenario: View featured users when there are no featured users
    When I send a GET request for "/users/featured"
    Then the response status should be "200"
    And the JSON response should have 0 "$.users.*"
  
  Scenario: Update featured users
    When I send a PUT request to "/users/featured" with the following:
      """
      {
          "users": [
            { "username": "testuser" }
          ]
      }
      """
    Then the response status should be "200"
    And the JSON response should have 1 "$.users.*"
    And the JSON response should have "$.users.featured_position" with the text "0"
    When I send a GET request for "/users/featured"
    Then the response status should be "200"
    And the JSON response should have 1 "$.users.*"
  
  Scenario: View featured users in order
    Given 3 featured music guides exist
    When I send a PUT request to "/users/testuser" with the following:
      """
      {
          "user": {
              "status": 1,
              "featured_position": 3
          }
      }
      """
    Then the response status should be "200"
    When I send a GET request for "/users/featured"
    Then the response status should be "200"
    And the JSON response should have 4 "$.users.*"
    And the JSON response should have "$.users[0].featured_position" with the text "0"
    And the JSON response should not have "$.users[0].username" with the text "testuser"
  
  Scenario: View featured users when there are some featured users
    When I send a GET request for "/users/featured"
    Then the response status should be "200"
    And the JSON response should have 0 "$.users.*"

  Scenario: View unfeatured users when there are some featured users
    When I send a GET request for "/users/featured?featured=0"
    Then the response status should be "200"
    And the JSON response should have 0 "$.users.*"

  Scenario: Update an individual user's featured position
    When I send a PUT request to "/users/testuser" with the following:
      """
      {
          "user": {
              "featured_position": null
          }
      }
      """
      Then the response status should be "200"
      And the JSON response should have "$.user.featured_position" as nil
  
  Scenario: Update an individual user's featured position
    When I send a PUT request to "/users/testuser" with the following:
      """
      {
          "user": {
              "featured_position": 0
          }
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.user.featured_position" with the text "0"
    When I send a GET request for "/users/featured"
    Then the response status should be "200"
    And the JSON response should have 1 "$.users.*"
