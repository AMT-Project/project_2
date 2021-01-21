Feature: Basic operations on rules

  Background:
    Given there is a Rules server

  Scenario: create a rule unauthenticated
    Given I have a rule payload
    When I POST the rule payload to the /rules endpoint
    Then I receive a 401 status code

  Scenario: create a rule
    Given I have successfully registered my app
    Given I have a rule payload
    When I POST the rule payload to the /rules endpoint
    Then I receive a 201 status code

    #TODO FIX
  Scenario: create a rule then earn badge
    Given I have successfully registered my app
    Given I have a rule payload if "eventType1" then award badge "badgeName1"
    Given I have an event payload for event "eventType1" user "userRuleTesting"
    #When I POST the badge payload to the /badges endpoint
    When I have successfully registered a badge named "badgeName1"
    Then I receive a 201 status code
    When I POST the rule payload to the /rules endpoint
    Then I receive a 201 status code
    Then I POST the event payload to the /events endpoint for rule
    Then I receive a 201 status code
    Then I send a GET to the badges endpoint for URL in the userLocation header
    Then I receive a 200 status code
    And I receive a list of 1 badges