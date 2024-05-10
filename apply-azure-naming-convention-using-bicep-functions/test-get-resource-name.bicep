//=================================================================================
// Helper file to call the getResourceName function in tests and assert the result
//=================================================================================

// Arrange

import { getResourceName } from './naming-conventions.bicep'

param resourceType string
param workload string
param environment string
param region string
param instance string

param expectedResult string

// Act
var actualResult = getResourceName(resourceType, workload, environment, region, instance)

// Assert
assert assertResult = actualResult == expectedResult

