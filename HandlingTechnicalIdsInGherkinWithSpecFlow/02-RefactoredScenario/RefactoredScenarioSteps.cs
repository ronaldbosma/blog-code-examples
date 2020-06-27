using System;
using System.Linq;
using System.Collections.Generic;
using System.Text;
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
                person.Id = person.Name.GetHashCode();
            }

            _peopleRepositoryStub.AddRange(people);
        }

        [When(@"'(.*)' moves to '(.*)'")]
        public void WhenMovesTo(string name, string newAddress)
        {
            int personId = name.GetHashCode();
            _movingService.MovePerson(personId, newAddress);
        }

        [Then(@"the new address of '(.*)' is '(.*)'")]
        public void ThenTheNewAddressOfIs(string name, string expectedAddress)
        {
            int personId = name.GetHashCode();
            var person = _peopleRepositoryStub.GetById(personId);
            Assert.AreEqual(expectedAddress, person.Address);
        }
    }
}
