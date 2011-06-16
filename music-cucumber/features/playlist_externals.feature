Feature: Playlist Externals
  As an API client
  In order to do things with playlist externals
  I want to test CRUD for playlist externals
  
  Background:
    Given I send and accept JSON
    Given a user exists
    And a playlist exists
  
  Scenario: List playlist externals when there are no externals for the playlist
    When I send a GET request for "/playlists/:url_key"
    Then the response status should be "200"
    And the JSON response should have 0 "$.playlist.externals"
  
  Scenario: Create a playlist external
  
  Scenario: Update a playlist external
  
  Scenario: Delete a playlist external
