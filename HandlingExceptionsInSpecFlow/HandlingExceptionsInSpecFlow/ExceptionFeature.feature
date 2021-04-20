Feature: ExceptionFeature

Scenario: Retrieve existing person

    Given the person 'Buffy Summers' is registered
	When I retrieve 'Buffy Summers'
	Then the person 'Buffy Summers' is returned
    
Scenario: Retrieve unknown person

    Given no person is registered
	When I retrieve 'Buffy Summers'
	Then the error 'Person with name Buffy Summers not found' should be raised
    
Scenario: Should fail: retrieve person that exists but expect error

    Given the person 'Buffy Summers' is registered
	When I retrieve 'Buffy Summers'
	Then the error 'Person with name Buffy Summers not found' should be raised
    
Scenario: Should fail: retrieve unknown person but don't check error

    Given no person is registered
	When I retrieve 'Buffy Summers'
    
Scenario: Should fail: different error message expected

    Given no person is registered
	When I retrieve 'Buffy Summers'
	Then the error 'Something went wrong' should be raised
