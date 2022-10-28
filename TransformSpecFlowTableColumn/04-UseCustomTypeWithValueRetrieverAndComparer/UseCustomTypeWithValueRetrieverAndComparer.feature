Feature: UseCustomTypeWithValueRetrieverAndComparer


Scenario: Fails because column in Then is named Location

    This scenario fails because the CompareToSet extension method doesn't seem to look at the TableAliases attribute

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


Scenario: Succeeds because colum in Then is named Location Id

    This scenario succeeds because the column name in the Then is changed to Location Id so it matches with the LocationId property.
    The LocationIdValueComparer will convert the text to the id and do a comparison.

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
        | Date            | Location Id | Temperature |
        | 28 October 2022 | London      | 8           |
        | 29 October 2022 | London      | 9           |


Scenario: Also succeeds when Temperature is removed

    Because we use the CompareToSet extension method, we can also remove columns we don't want to compare.

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
        | Date            | Location Id |
        | 28 October 2022 | London      |
        | 29 October 2022 | London      |