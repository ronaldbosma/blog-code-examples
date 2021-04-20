using System.Threading.Tasks;
using HandlingExceptionsInSpecFlow.Support;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace HandlingExceptionsInSpecFlow
{
    [Binding]
    internal class PersonsSteps
    {
        private readonly PersonRepository _people = new PersonRepository();
        private string _actualPerson;

        private readonly ErrorContext _errorContext;

        public PersonsSteps(ErrorContext errorContext)
        {
            _errorContext = errorContext;
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
            _errorContext.TryExecute(() =>
                _actualPerson = _people.GetPersonByName(name)
            );
        }

        [When(@"I retrieve '(.*)' async")]
        public async Task WhenIRetrieveAsync(string name)
        {
            await _errorContext.TryExecuteAsync(async () =>
                _actualPerson = await _people.GetPersonByNameAsync(name)
            );
        }

        [Then(@"the person '(.*)' is returned")]
        public void ThenThePersonLivingAtIsReturned(string expectedName)
        {
            Assert.IsNotNull(_actualPerson, "No person retrieved");
            Assert.AreEqual(expectedName, _actualPerson);
        }
    }
}
