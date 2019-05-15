Feature: Persons
	Contains scenario's using pronouns

Scenario: John and Mary move in together using names

	Given a man called 'John H. Watson'
        And a woman called 'Mary Morstan'
        And 'John H. Watson' lives at '221B Baker Street, London'
        And 'Mary Morstan' lives at '123 Couldn't Find It, London'
    When 'John H. Watson' and 'Mary Morstan' move in together at '221B Baker Street, London'
    Then 'John H. Watson' his address is '221B Baker Street, London'
        And 'Mary Morstan' her address is '221B Baker Street, London'

    
Scenario: John and Mary move in together using pronouns

	Given a man called 'John H. Watson'
        And a woman called 'Mary Morstan'
        And he lives at '221B Baker Street, London'
        And she lives at '123 Couldn't Find It, London'
    When they move in together at '221B Baker Street, London'
    Then his address is '221B Baker Street, London'
        And her address is '221B Baker Street, London'