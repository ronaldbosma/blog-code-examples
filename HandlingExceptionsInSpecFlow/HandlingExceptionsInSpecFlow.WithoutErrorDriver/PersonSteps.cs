using System;
using HandlingExceptionsInSpecFlow.Shared;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace HandlingExceptionsInSpecFlow.WithoutErrorDriver
{
    [Binding]
    internal class PersonSteps
    {
        private readonly PersonRepository _people = new PersonRepository();
        private string _actualName;
        private Exception _actualException;

        [Given(@"the person '(.*)' is registered")]
        public void GivenThePersonIsRegistered(string name)
        {
            _people.AddPerson(name);
        }

        [Then(@"the person '(.*)' is returned")]
        public void ThenThePersonIsReturned(string expectedName)
        {
            Assert.IsNotNull(_actualName, "No person retrieved");
            Assert.AreEqual(expectedName, _actualName);
        }

        [Given(@"no person is registered")]
        public void GivenNoPersonIsRegistered()
        {
            _people.Clear();
        }

        [When(@"I retrieve the person '(.*)'")]
        public void WhenIRetrieveThePerson(string name)
        {
            try
            {
                _actualName = _people.GetPersonByName(name);
            }
            catch (Exception ex)
            {
                _actualException = ex;
            }
        }

        [Then(@"the error '(.*)' should be raised")]
        public void ThenTheErrorShouldBeRaised(string expectedErrorMessage)
        {
            Assert.IsNotNull(_actualException, "No error was raised");
            Assert.AreEqual(expectedErrorMessage, _actualException.Message);

            // Clear the caught exception so it's not marked as unexpected in the AfterScenario hook
            _actualException = null;
        }

        [AfterScenario]
        public void CheckForUnexpectedExceptionsAfterEachScenario()
        {
            Assert.IsNull(_actualException, $"No exception was expected to be raised but found exception: {_actualException}");
        }
    }
}
