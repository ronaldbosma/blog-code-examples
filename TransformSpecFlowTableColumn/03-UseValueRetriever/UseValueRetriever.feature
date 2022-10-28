Feature: Use Value Retriever


Scenario: Succeeds because we use Value Retriever

    This scenario succeeds because the table alias will make sure the Location column is matched to the LocationId property.
    After that, the value retriever will convert the location name to the correct id.

    Given the weather forecasts
        | Date            | Location  | Temperature |
        | 28 October 2022 | Amsterdam | 22          |
        | 28 October 2022 | London    | 8           |
        | 28 October 2022 | Madrid    | 31          |
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location | Temperature |
        | 28 October 2022 | 2        | 8           |


Scenario: Fails because Location cannot be compared

    This scenario fails because we can't compare the Location column to the LocationId property. Using a ValueComparer could be a possible solution.
    However, the column name doesn't get passed into the ValueComparer like it gets passed into a ValueRetriever, making it harder to create a good implementation.

    Given the weather forecasts
        | Date            | Location  | Temperature |
        | 28 October 2022 | Amsterdam | 22          |
        | 28 October 2022 | London    | 8           |
        | 28 October 2022 | Madrid    | 31          |
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location | Temperature |
        | 28 October 2022 | London   | 8           |