﻿Feature: ExceptionFeatureAsync

Scenario: Retrieve existing person successfully

    Given the person 'Buffy Summers' is registered
    When I retrieve the person 'Buffy Summers' async
    Then the person 'Buffy Summers' is returned
    
Scenario: Retrieve unknown person and expect an error

    Given no person is registered
    When I retrieve the person 'Buffy Summers' async
    Then the error 'Person with name Buffy Summers not found' should be raised
    
Scenario: Should fail: retrieve person that exists but expect error

    Given the person 'Buffy Summers' is registered
    When I retrieve the person 'Buffy Summers' async
    Then the error 'Person with name Buffy Summers not found' should be raised
    
Scenario: Should fail: retrieve unknown person but don't check error

    Given no person is registered
    When I retrieve the person 'Buffy Summers' async
    
Scenario: Should fail: different error message expected

    Given no person is registered
    When I retrieve the person 'Buffy Summers' async
    Then the error 'Something went wrong' should be raised