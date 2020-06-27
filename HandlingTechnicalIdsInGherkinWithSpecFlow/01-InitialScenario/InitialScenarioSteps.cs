using HandlingTechnicalIdsInGherkinWithSpecFlow.Shared;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace HandlingTechnicalIdsInGherkinWithSpecFlow.InitialScenario
{
    [Binding]
    class InitialScenarioSteps
    {
        private readonly PeopleRepositoryStub _peopleRepositoryStub = new PeopleRepositoryStub();
        private readonly MovingService _movingService;

        public InitialScenarioSteps()
        {
             _movingService = new MovingService(_peopleRepositoryStub);
        }

        [Given(@"the following people")]
        public void GivenTheFollowingPeople(Table table)
        {
            var people = table.CreateSet<Person>();
            _peopleRepositoryStub.AddRange(people);
        }

        [When(@"person (.*) moves to '(.*)'")]
        public void WhenPersonMovesTo(int personId, string newAddress)
        {
            _movingService.MovePerson(personId, newAddress);
        }

        [Then(@"the new address of person (.*) is '(.*)'")]
        public void ThenTheNewAddressOfPersonIs(int personId, string expectedAddress)
        {
            var person = _peopleRepositoryStub.GetById(personId);
            Assert.AreEqual(expectedAddress, person.Address);
        }
    }
}
