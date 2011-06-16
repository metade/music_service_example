Feature: Playlist Tracks
  As an API client
  In order to do things with playlist tracks
  I want to test CRUD for playlist tracks
  
  Background:
    Given I send and accept JSON
    Given a user exists
    And a playlist exists
  
  Scenario: List playlist tracks when there are no tracks for the playlist
    When I send a GET request for "/playlists/:url_key"
    Then the response status should be "200"
    And the JSON response should have 0 "$.playlist.playlists_tracks"
  
  Scenario: Create a playlist track
    When I send a POST request to "/playlists/:url_key/tracks" with the following:
      """
      {
          "playlists_track": {
              "medium_synopsis": "Comment",
              "track": {
                  "artist_gid": "f181961b-20f7-459e-89de-920ef03c7ed0",
                  "artist_name": "The Strokes",
                  "title": "Under the cover of darkness"
              }
          }
      }
      """
    Then the response status should be "200"
    And show me the response
    And the JSON response should have the following:
      | jsonpath                          | value   |
      | $.playlists_track.medium_synopsis | Comment |
  
  Scenario: List playlist tracks
    Given a track exists
    When I send a GET request for "/playlists/:url_key"
    Then the response status should be "200"
    And the JSON response should have 1 "$.playlist.playlists_tracks"
  
  Scenario: Get a playlist track
    Given a track exists
    When I send a GET request for "/playlists/@playlist_id/tracks/@track_id"
    Then the response status should be "200"
    And show me the response
    And the JSON response should have 1 "$.playlists_track"
  
  Scenario: Update a playlist track
  Given a track exists
  When I send a PUT request to "/playlists/@playlist_id/tracks/@track_id" with the following:
      """
      {
          "playlists_track": {
              "medium_synopsis": "Test Comment",
              "track": {
                  "artist_gid": "f181961b-20f7-459e-89de-920ef03c7ed0",
                  "artist_name": "The Strokes",
                  "title": "Under the cover of darkness"
              }
          }
      }
      """
    Then the response status should be "200"
      And show me the response
      And the JSON response should have the following:
      | jsonpath                                          | value                                                   |
      | $.playlists_track.medium_synopsis                 | Test Comment                                            |

  Scenario: Delete a playlist track
  
  Scenario: Update playlist track positions