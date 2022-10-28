Feature: Init


Scenario: Succeeds because Table has Location Id

    This scenario succeeds because the table matches the Weather Forecast class.
    Using the Location Id  in the table is not very reader friendly though.

    Given the weather forecasts
        | Date            | Location Id | Temperature |
        | 28 October 2022 | 1           | 22          |
        | 28 October 2022 | 2           | 8           |
        | 28 October 2022 | 3           | 31          |
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location Id | Temperature |
        | 28 October 2022 | 2           | 8           |


Scenario: Fails because Table has Location

    This scenario will fail because the Weather Forecast doesn not have a Location property

    Given the weather forecasts
        | Date            | Location  | Temperature |
        | 28 October 2022 | Amsterdam | 22          |
        | 28 October 2022 | London    | 8           |
        | 28 October 2022 | Madrid    | 31          |
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location | Temperature |
        | 28 October 2022 | London   | 8           |
