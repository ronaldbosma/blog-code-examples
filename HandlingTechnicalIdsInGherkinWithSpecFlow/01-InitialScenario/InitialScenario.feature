Feature: Initial Scenario

Scenario: Person moves to new address

    Given the following people
        | Id | Address                           |
        | 1  | 221B Baker Street, London, UK     |
        | 2  | 1630 Revello Drive, Sunnydale, US |
        | 3  | 31 Spooner Street, Quahog, US     |
        | 4  | 12 Grimmauld Place, London, UK    |
    When person 3 moves to '742 Evergreen Terrace, Springfield, US'
    Then the new address of person 3 is '742 Evergreen Terrace, Springfield, US'
