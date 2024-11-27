import { replacePlaceholders } from './replace-placeholders.bicep'

// Arrange
param input string
param placeholders object

param expectedResult string

// Act
var actualResult = replacePlaceholders(input, placeholders)

// Assert
assert assertResult = actualResult == expectedResult
