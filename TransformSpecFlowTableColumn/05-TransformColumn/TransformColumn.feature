Feature: Transform Column


Scenario: Success with Column Transformation

    With the transformed column we can use the Location Name in both the Given and Then step

    Given the weather forecasts
        | Date            | Location  | Temperature |
        | 28 October 2022 | Amsterdam | 22          |
        | 28 October 2022 | London    | 8           |
        | 28 October 2022 | Madrid    | 31          |
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location | Temperature |
        | 28 October 2022 | London   | 8           |


Scenario: Success with Column Transformation and expected Table does not have all properties

    With the transform column solution, we can use CompareToSet. So we don't need to specify all properties.

    Given the weather forecasts
        | Date            | Location  | Temperature |
        | 28 October 2022 | Amsterdam | 22          |
        | 28 October 2022 | London    | 8           |
        | 28 October 2022 | Madrid    | 31          |
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location |
        | 28 October 2022 | London   |


Scenario: Fails because expected data is wrong

    To show that the comparison does its job, the data in the Then step is wrong.
    The only down side is that the error message shows the expected and actual LocationId instead of the location name.
    This might be confusing for users.

    Given the weather forecasts
        | Date            | Location  | Temperature |
        | 28 October 2022 | Amsterdam | 22          |
        | 28 October 2022 | London    | 8           |
        | 28 October 2022 | Madrid    | 31          |
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location |
        | 28 October 2022 | Madrid   |
