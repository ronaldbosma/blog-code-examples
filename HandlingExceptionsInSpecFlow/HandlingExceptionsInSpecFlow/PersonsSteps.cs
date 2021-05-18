using System.Threading.Tasks;
using HandlingExceptionsInSpecFlow.Shared;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace HandlingExceptionsInSpecFlow
{
    [Binding]
    internal class PersonsSteps
    {
        private readonly PersonRepository _people = new PersonRepository();
        private string _actualName;

        private readonly ErrorDriver _errorDriver;

        public PersonsSteps(ErrorDriver errorDriver)
        {
            _errorDriver = errorDriver;
        }

        [Given(@"the person '(.*)' is registered")]
        public void GivenThePersonLivingAtIsRegistered(string name)
        {
            _people.AddPerson(name);
        }

        [Given(@"no person is registered")]
        public void GivenNoPersonIsRegistered()
        {
            _people.Clear();
        }

        [When(@"I retrieve '(.*)'")]
        public void WhenIRetrieve(string name)
        {
            _errorDriver.TryExecute(() =>
                _actualName = _people.GetPersonByName(name)
            );
        }

        [When(@"I retrieve '(.*)' async")]
        public async Task WhenIRetrieveAsync(string name)
        {
            await _errorDriver.TryExecuteAsync(async () =>
                _actualName = await _people.GetPersonByNameAsync(name)
            );
        }

        [Then(@"the person '(.*)' is returned")]
        public void ThenThePersonLivingAtIsReturned(string expectedName)
        {
            Assert.IsNotNull(_actualName, "No person retrieved");
            Assert.AreEqual(expectedName, _actualName);
        }
    }
}
