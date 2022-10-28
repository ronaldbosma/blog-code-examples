Feature: Transform Column


Scenario: Success with Column Transformation

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


Scenario: Success with Column Transformation and expected Table does not have all properties

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
        | Date            | Location |
        | 28 October 2022 | London   |
        | 29 October 2022 | London   |


Scenario: Fails because expected data is wrong

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
        | Date            | Location |
        | 28 October 2022 | Madrid   |
        | 29 October 2022 | Madrid   |