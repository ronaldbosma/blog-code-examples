Feature: ExceptionFeature

Scenario: Retrieve existing person

    Given the person 'Buffy Summers' living at '1630 Revello Drive, Sunnydale' is registered
	When I retrieve 'Buffy Summers'
	Then the person 'Buffy Summers' living at '1630 Revello Drive, Sunnydale' is returned
    
Scenario: Retrieve unknown person

    Given no person is registered
	When I retrieve 'Buffy Summers'
	Then the error 'Person with name Buffy Summers not found' should be raised
    
Scenario: Should fail: retrieve person that exists but expect error

    Given the person 'Buffy Summers' living at '1630 Revello Drive, Sunnydale' is registered
	When I retrieve 'Buffy Summers'
	Then the error 'Person with name Buffy Summers not found' should be raised
    
Scenario: Should fail: retrieve unknown person but expect peron to be returned

    Given no person is registered
	When I retrieve 'Buffy Summers'
	#Then the person 'Buffy Summers' living at '1630 Revello Drive, Sunnydale' is returned
