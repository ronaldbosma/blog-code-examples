using System;
using HandlingTechnicalIdsInGherkinWithSpecFlow.Shared;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace HandlingTechnicalIdsInGherkinWithSpecFlow.RefactoredScenario
{
    [Binding]
    class RefactoredScenarioSteps
    {
        private readonly PeopleRepositoryStub _peopleRepositoryStub = new PeopleRepositoryStub();
        private readonly MovingService _movingService;

        public RefactoredScenarioSteps()
        {
            _movingService = new MovingService(_peopleRepositoryStub);
        }

        [Given(@"the following people")]
        public void GivenTheFollowingPeople(Table table)
        {
            var people = table.CreateSet<Person>();
            foreach (var person in people)
            {
                person.Id = NameToId(person.Name);
            }

            _peopleRepositoryStub.AddRange(people);
        }

        [When(@"'(.*)' moves to '(.*)'")]
        public void WhenMovesTo(string name, string newAddress)
        {
            Guid personId = NameToId(name);
            _movingService.MovePerson(personId, newAddress);
        }

        [Then(@"the new address of '(.*)' is '(.*)'")]
        public void ThenTheNewAddressOfIs(string name, string expectedAddress)
        {
            Guid personId = NameToId(name);
            var person = _peopleRepositoryStub.GetById(personId);
            Assert.AreEqual(expectedAddress, person.Address);
        }

        private static Guid NameToId(string name)
        {
            // Convert the name to an integer value and make sure it's always a positive number
            int personId = Math.Abs(name.GetHashCode());
            // Convert the integer personId to a string of 32 numbers so we can create a valid Guid
            string personIdGuid = personId.ToString().PadLeft(32, '0');
            
            return Guid.ParseExact(personIdGuid, "N");
        }
    }
}
