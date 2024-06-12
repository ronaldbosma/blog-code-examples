//=============================================================================
// Tests for the replacePlaceholders function
// 
// - Run the tests with the command:  bicep test .\tests.bicep
//=============================================================================

test ReplacePlaceholders_NoPlaceholderInInput_InputReturned 'test-replace-placeholders.bicep' = {
  params: {
    input: 'zero'
    placeholders: { }
    expectedResult: 'zero'
  }
}

test ReplacePlaceholders_OnePlaceholder_PlaceholderReplaced 'test-replace-placeholders.bicep' = {
  params: {
    input: 'first = $(first)'
    placeholders: {
      first: 'one'
    }
    expectedResult: 'first = one'
  }
}

test ReplacePlaceholders_SamePlaceholderMultipleTimes_PlaceholderReplacedForAllOccurences 'test-replace-placeholders.bicep' = {
  params: {
    input: 'first = $(first); anotherFirst = $(first); andAnotherFirst = $(first)'
    placeholders: {
      first: 'one'
    }
    expectedResult: 'first = one; anotherFirst = one; andAnotherFirst = one'
  }
}

test ReplacePlaceholders_MultiplePlaceholders_AllPlaceholdersReplaced 'test-replace-placeholders.bicep' = {
  params: {
    input: 'first = $(first); second = $(second); third = $(third)'
    placeholders: {
      first: 'one'
      second: '2'
      third: 'III'
    }
    expectedResult: 'first = one; second = 2; third = III'
  }
}

test ReplacePlaceholders_InputIsMultilineString_AllPlaceholdersReplaced 'test-replace-placeholders.bicep' = {
  params: {
    input: '''
      first = $(first)
      second = $(second)
      third = $(third)
      '''
    placeholders: {
      first: 'one'
      second: '2'
      third: 'III'
    }
    expectedResult: '''
      first = one
      second = 2
      third = III
      '''
  }
}
