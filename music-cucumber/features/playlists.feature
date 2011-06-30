Feature: Playlists
  As an API client
  In order to do things with playlists
  I want to test CRUD for playlists
  
  Background:
    Given I send and accept JSON
  
  Scenario: List playlists when there are no playlists
    When I send a GET request for "/playlists"
    Then the response status should be "200"
    And the JSON response should have 0 "$.playlists"
  
  Scenario: Create a playlist
    Given a user exists
    When I send a POST request to "/users/testuser/playlists" with the following:
      """
      {
          "playlist": {
              "medium_synopsis": "My pick of the singles of the week - aren't they great?",
              "short_synopsis": "My pick of the singles of the week",
              "title": "Singles of the Week"
          }
      }
      """
    Then the response status should be "201"
    And show me the response
    And the JSON response should have the following:
      | jsonpath                   | value                                                   |
      | $.playlist.title           | Singles of the Week                                     |
      | $.playlist.short_synopsis  | My pick of the singles of the week                      |
      | $.playlist.medium_synopsis | My pick of the singles of the week - aren't they great? |
    And the JSON response should have "$.playlist.promoted_at" as nil
    # And the JSON response should have "$.playlist.updated_at" as nil
      
  Scenario: View a playlist
    Given a user exists
    And a playlist exists
    When I send a GET request for "/playlists/:url_key"
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath                   | value                      |
      | $.playlist.title           | Test Playlist              |
      | $.playlist.short_synopsis  | A short playlist synopsis  |
      | $.playlist.medium_synopsis | A medium playlist synopsis |
    And the JSON response should have "$.playlist.promoted_at" as nil
    # And the JSON response should have "$.playlist.updated_at" as nil
  
  Scenario: Update a playlist
    Given a user exists
    And a playlist exists
    When I send a PUT request to "/playlists/:url_key" with the following:
      """
      {
          "playlist": {
              "medium_synopsis": "A fantastic medium playlist synopsis",
              "short_synopsis": "A fantastic short playlist synopsis",
              "title": "Fantastic Playlist"
          }
      }
      """
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath                   | value                                |
      | $.playlist.title           | Fantastic Playlist                   |
      | $.playlist.short_synopsis  | A fantastic short playlist synopsis  |
      | $.playlist.medium_synopsis | A fantastic medium playlist synopsis |
    And the JSON response should have "$.playlist.promoted_at" as nil
    
  Scenario: List draft playlists
    Given a user exists
    And a playlist exists
    When I send a PUT request to "/playlists/:url_key" with the following:
      """
      {
          "playlist": {
              "medium_synopsis": "A fantastic medium playlist synopsis",
              "short_synopsis": "A fantastic short playlist synopsis",
              "title": "Fantastic Playlist",
              "status":0
          }
      }
      """
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath                   | value                                |
      | $.playlist.title           | Fantastic Playlist                   |
      | $.playlist.short_synopsis  | A fantastic short playlist synopsis  |
      | $.playlist.medium_synopsis | A fantastic medium playlist synopsis |
      | $.playlist.status          | 0                                    |
    And the JSON response should have "$.playlist.promoted_at" as nil
    When I send a GET request for "/playlists/draft"
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath                   | value                                |
      | $.count                    | 1                                    |
      | $.playlists..title         | Fantastic Playlist                   |
      | $.playlists..status        | 0                                    |

  Scenario: List published playlists
    Given a user exists
    And a playlist exists
    When I send a PUT request to "/playlists/:url_key" with the following:
      """
      {
          "playlist": {
              "medium_synopsis": "A fantastic medium playlist synopsis",
              "short_synopsis": "A fantastic short playlist synopsis",
              "title": "Fantastic Playlist",
              "status":1
          }
      }
      """
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath                   | value                                |
      | $.playlist.title           | Fantastic Playlist                   |
      | $.playlist.short_synopsis  | A fantastic short playlist synopsis  |
      | $.playlist.medium_synopsis | A fantastic medium playlist synopsis |
      | $.playlist.status          | 1                                    |
    And the JSON response should have "$.playlist.promoted_at" as nil
    
    When I send a GET request for "/playlists/published"
    Then the response status should be "200"
    And the JSON response should have the following:
      | jsonpath                   | value                                |
      | $.count                    | 1                                    |
      | $.playlists..title         | Fantastic Playlist                   |

  Scenario: Delete a playlist
    Given a user exists
    And a playlist exists
    When I send a DELETE request to "/playlists/:url_key"
    Then the response status should be "200"
    And the response should be empty
