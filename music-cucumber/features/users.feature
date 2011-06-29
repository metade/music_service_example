Feature: Users
  As an API client
  In order to do things with users
  I want to test CRUD for users
  
  Background:
    Given I send and accept JSON
  
  Scenario: List users when there are no users
    When I send a GET request for "/users"
    Then the response status should be "200"
    And the JSON response should have 0 "$.users.*"
  
  Scenario: Create a user
    When I send a POST request to "/users" with the following:
      """
      {
          "user": {
              "artist_gid": null,
              "bbcid": 5885690,
              "is_guide": 1,
              "is_superuser": 0,
              "medium_synopsis": "Sequi quibusdam recusandae enim alias iste quisquam quia. In nam facilis minima iusto. Est soluta odio voluptas. Voluptas impedit aut quos molestiae provident officiis quia similique.Ab ipsum doloribus qui nesciunt illum minima quia magni. Sint qui dicta iste a non. Natus in ea ex. Aspernatur reiciendis molestiae iure cumque repudiandae aut itaque earum.Quo quo ut et eaque. Itaque aliquam fugit qui. Omnis dicta inventore odio distinctio odit autem.",
              "name": "Marquis Kertzmann",
              "short_synopsis": "Voluptatibus minus quia vel.",
              "status": 1,
              "username": "marquiskertzmann"
          }
      }
      """
    Then the response status should be "200"
    And show me the response
    And the JSON response should have the following:
      | jsonpath              | value                        |
      | $.user.username       | marquiskertzmann             |
      | $.user.name           | Marquis Kertzmann            |
      | $.user.short_synopsis | Voluptatibus minus quia vel. |
      | $.user.is_guide       | 1                            |
      | $.user.is_superuser   | 0                            |
    And the JSON response should have "$.user.artist_gid" as nil
    And the JSON response should have "$.user.featured_position" as nil
    And the JSON response should have "$.user.brand_pid" as nil
  
  Scenario: Create the same user twice
    Given a user exists
    When I send a POST request to "/users" with the following:
      """
      {
          "user": {
              "bbcid": 5885690,
              "name": "Test User",
              "username": "testuser"
          }
      }
      """
      # Then the response status should be "403" - is this the correct status code?
      When I send a GET request for "/users"
      Then the response status should be "200"
      And the JSON response should have 1 "$.users.*"
  
  Scenario: Get a user
    Given a user exists
    When I send a GET request to "/users/testuser"
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath            | value     |
      | $.user.username     | testuser  |
      | $.user.name         | Test User |
      | $.user.is_guide     | 0         |
      | $.user.is_superuser | 0         |
  
  Scenario: Update a user
    Given a user exists
    When I send a PUT request to "/users/testuser" with the following:
      """
      {
          "user": {
              "is_guide": 1,
              "status": 1,
              "brand_pid": 'foobar',
			  "username": "testuser"
          }
      }
      """
      Then the response status should be "200"
      And show me the response
      And the JSON response should have the following:
        | jsonpath            | value     |
        | $.user.username     | testuser  |
        | $.user.name         | Test User |
        | $.user.is_guide     | 1         |
        | $.user.is_superuser | 0         |
        | $.user.status       | 1         |
        | $.user.brand_pid    | foobar    |
  
  Scenario: Delete a user
    Given a user exists
    When I send a DELETE request to "/users/testuser"
    Then the response status should be "200"
    And the response should be empty

  Scenario: View editors (i.e. is_superuser=1)
  
  Scenario: View music guides (i.e. is_guide=1)
