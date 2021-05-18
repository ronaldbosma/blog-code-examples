using TechTalk.SpecFlow;

namespace HandlingExceptionsInSpecFlow
{
    [Binding]
    internal class ErrorSteps
    {
        private readonly ErrorDriver _errorDriver;

        public ErrorSteps(ErrorDriver errorDriver)
        {
            _errorDriver = errorDriver;
        }

        [Then(@"the error '(.*)' should be raised")]
        public void ThenTheErrorShouldBeRaised(string expectedErrorMessage)
        {
            _errorDriver.AssertExceptionWasRaisedWithMessage(expectedErrorMessage);
        }

        [AfterScenario]
        public void CheckForUnexpectedExceptionsAfterEachScenario()
        {
            _errorDriver.AssertNoUnexpectedExceptionsRaised();
        }
    }
}
