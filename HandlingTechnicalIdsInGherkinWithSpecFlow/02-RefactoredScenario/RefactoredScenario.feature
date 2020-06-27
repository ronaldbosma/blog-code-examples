Feature: Refactored Scenario

Scenario: Person moves to new address

    Given the following people
        | Name            | Address                           |
        | Sherlock Holmes | 221B Baker Street, London, UK     |
        | Buffy Summers   | 1630 Revello Drive, Sunnydale, US |
        | Peter Griffin   | 31 Spooner Street, Quahog, US     |
        | Sirius Black    | 12 Grimmauld Place, London, UK    |
    When 'Peter Griffin' moves to '742 Evergreen Terrace, Springfield, US'
    Then the new address of 'Peter Griffin' is '742 Evergreen Terrace, Springfield, US'