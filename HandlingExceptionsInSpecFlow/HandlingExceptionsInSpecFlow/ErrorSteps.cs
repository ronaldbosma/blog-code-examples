using System;
using System.Collections.Generic;
using System.Text;
using TechTalk.SpecFlow;

namespace HandlingExceptionsInSpecFlow
{
    [Binding]
    class ErrorSteps
    {
        private readonly ErrorContext _errorContext;

        public ErrorSteps(ErrorContext errorContext)
        {
            _errorContext = errorContext;
        }

        [Then(@"the error '(.*)' should be raised")]
        public void ThenTheErrorShouldBeRaised(string expectedErrorMessage)
        {
            _errorContext.AssertExceptionWasRaisedWithMessage(expectedErrorMessage);
        }

        [AfterScenario]
        public void CheckForUnexpectedExceptionsAfterEachScenario()
        {
            _errorContext.AssertNoUnexpectedExceptionsRaised();
        }
    }
}
