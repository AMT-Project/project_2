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