using HandlingExceptionsInSpecFlow.Support;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace HandlingExceptionsInSpecFlow
{
    [Binding]
    internal class PersonsSteps
    {
        private readonly PersonRepository _people = new PersonRepository();
        private Person _actualPerson;

        private readonly ErrorContext _errorContext;

        public PersonsSteps(ErrorContext errorContext)
        {
            _errorContext = errorContext;
        }

        [Given(@"the person '(.*)' living at '(.*)' is registered")]
        public void GivenThePersonLivingAtIsRegistered(string name, string address)
        {
            _people.AddPerson(name, address);
        }

        [Given(@"no person is registered")]
        public void GivenNoPersonIsRegistered()
        {
            _people.Clear();
        }

        [When(@"I retrieve '(.*)'")]
        public void WhenIRetrieve(string name)
        {
            _errorContext.TryExecute(() =>
                _actualPerson = _people.GetPersonByName(name)
            );
        }

        [Then(@"the person '(.*)' living at '(.*)' is returned")]
        public void ThenThePersonLivingAtIsReturned(string expectedName, string expectedAddress)
        {
            Assert.IsNotNull(_actualPerson, "No person retrieved");
            Assert.AreEqual(expectedName, _actualPerson.Name);
            Assert.AreEqual(expectedAddress, _actualPerson.Address);
        }
    }
}
