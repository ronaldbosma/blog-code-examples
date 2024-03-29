﻿Feature: Use Test Model


Scenario: Succeeds because we use Test Model

    This scenario succeeds because the table matches the Weather Forecast test model.

    Given the weather forecasts
        | Date            | Location  | Temperature |
        | 28 October 2022 | Amsterdam | 22          |
        | 28 October 2022 | London    | 8           |
        | 28 October 2022 | Madrid    | 31          |
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location | Temperature |
        | 28 October 2022 | London   | 8           |


Scenario: Fails because Temperature is not specified in expected Weather Forecast table

    This scenario fails because the Temperature column is ommited in the expected Weather Forecast table.
    The actual Weather Forecasts doe have a Temperature though.
    The CompareToSet extension method would have ignored this, but we can't use it now.

    Given the weather forecasts
        | Date            | Location  | Temperature |
        | 28 October 2022 | Amsterdam | 22          |
        | 28 October 2022 | London    | 8           |
        | 28 October 2022 | Madrid    | 31          |
    When the weather forecast for 'London' on '28 October 2022' is retrieved
    Then the following weather forecast is returned
        | Date            | Location |
        | 28 October 2022 | London   |
