Feature: UseCustomTypeWithValueRetrieverAndComparer


Scenario: Succeeds because colum in Then is named Location Id

    This scenario succeeds because the table alias will make sure the Location column is matched to the LocationId property.
    After that, the value retriever will convert the location name to the LocationId type.
    The value comparer will convert the location name to a LocationId and do the comparison.

    Given the weather forecasts
        | Date            | Location  | Temperature |
        | 28 October 2022 | Amsterdam | 22          |
        | 28 October 2022 | London    | 8           |
        | 28 October 2022 | Madrid    | 31          |
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location | Temperature |
        | 28 October 2022 | London   | 8           |


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
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location |
        | 28 October 2022 | London   |
