Feature: Geo-coding evaluation

  Scenario: Get the coding of an address
    Given a context
      And the prefix f as "http://dh.tamu.edu/ns/fabulator/1.0#"
      And the prefix g as "http://dh.tamu.edu/ns/fabulator/geo/1.0#"
    When I run the expression (g:coding("")/longitude)
    Then I should get 1 item
      And item 0 should be ['-96.322044']
