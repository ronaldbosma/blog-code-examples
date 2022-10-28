Feature: Init


Scenario: Succeeds because Table has Location Id

    This scenario succeeds because the table matches the Weather Forecast class.
    Using the Location Id is not very reader friendly though.

    Given the weather forecasts
        | Date            | Location Id | Temperature |
        | 28 October 2022 | 1           | 22          |
        | 29 October 2022 | 1           | 21          |
        | 28 October 2022 | 2           | 8           |
        | 29 October 2022 | 2           | 9           |
        | 28 October 2022 | 3           | 31          |
        | 29 October 2022 | 3           | 33          |
    When the weather forecasts for 2 are retrieved
    Then the following weather forecasts are returned
        | Date            | Location Id | Temperature |
        | 28 October 2022 | 2           | 8           |
        | 29 October 2022 | 2           | 9           |


Scenario: Fails because Table has Location

    This scenario will fail because the Weather Forecast doesn not have a Location property

    Given the weather forecasts
        | Date            | Location  | Temperature |
        | 28 October 2022 | Amsterdam | 22          |
        | 29 October 2022 | Amsterdam | 21          |
        | 28 October 2022 | London    | 8           |
        | 29 October 2022 | London    | 9           |
        | 28 October 2022 | Madrid    | 31          |
        | 29 October 2022 | Madrid    | 33          |
    When the weather forecasts for 'London' are retrieved
    Then the following weather forecasts are returned
        | Date            | Location | Temperature |
        | 28 October 2022 | London   | 8           |
        | 29 October 2022 | London   | 9           |