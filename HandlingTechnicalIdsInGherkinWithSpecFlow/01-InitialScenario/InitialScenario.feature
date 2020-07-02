Feature: Initial Scenario

Scenario: Person moves to new address

    Given the following people
        | Id                                   | Address                           |
        | 9A9EE974-9062-4AB3-98C8-E83B0A5A3BAA | 221B Baker Street, London, UK     |
        | 70EC5DE6-F569-4092-AF58-DA857F44279E | 1630 Revello Drive, Sunnydale, US |
        | 0545383F-28E7-4968-9525-11829915ED89 | 31 Spooner Street, Quahog, US     |
        | EF03C690-6F29-43F0-931F-546938F2869F | 12 Grimmauld Place, London, UK    |
    When person '0545383F-28E7-4968-9525-11829915ED89' moves to '742 Evergreen Terrace, Springfield, US'
    Then the new address of person '0545383F-28E7-4968-9525-11829915ED89' is '742 Evergreen Terrace, Springfield, US'
