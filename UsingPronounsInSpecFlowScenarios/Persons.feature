Feature: Persons
	Contains scenario's using pronouns

Scenario: John and Mary move in together using names

	Given a man called 'John H. Watson'
        And 'John H. Watson' lives at '221B Baker Street, London'
        And a woman called 'Mary Morstan'
        And 'Mary Morstan' lives at '123 Couldn't Find It, London'
    When 'John H. Watson' and 'Mary Morstan' move in together at '221B Baker Street, London'
    Then 'Mary Morstan' her address is '221B Baker Street, London'
        And 'John H. Watson' his address is '221B Baker Street, London'

    
Scenario: John and Mary move in together using pronouns

	Given a man called 'John H. Watson'
        And he lives at '221B Baker Street, London'
        And a woman called 'Mary Morstan'
        And she lives at '123 Couldn't Find It, London'
    When they move in together at '221B Baker Street, London'
    Then her address is '221B Baker Street, London'
        And his address is '221B Baker Street, London'
        
