Feature: GenericTypes

For this feature the conversion and comparison of the DateOnly and Temperature types is done 
by the generic ParsableValueRetriever<T> and ParsableValueComparer<T>

Scenario: Create weather forecasts from a table and compare them with another table

    When the following table is converted into weather forecasts
        | Date          | Minimum Temperature | Maximum Temperature |
        | 13 April 2024 | 13 °C               | 23 °C               |
        | 14 April 2024 | 10 °C               | 15 °C               |
        | 15 April 2024 | 7 °C                |                     | # Leave the maximum temperature empty so it is null
    Then the following weather forecasts are created
        | Date          | Minimum Temperature | Maximum Temperature |
        | 13 April 2024 | 13 °C               | 23 °C               |
        | 14 April 2024 | 50 °F               | 59 °F               | # Values in Fahrenheit instead of Celsius
        | 15 April 2024 | 7 °C                |                     |
