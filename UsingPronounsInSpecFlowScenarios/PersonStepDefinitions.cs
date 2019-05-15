using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace UsingPronounsInSpecFlowScenarios
{
    [Binding]
    class PersonStepDefinitions
    {
        [Given(@"a man called (.*)")]
        public void GivenAManCalled(Person man)
        {
            man.Gender = Gender.Man;
        }

        [Given(@"a woman called (.*)")]
        public void GivenAWomanCalled(Person woman)
        {
            woman.Gender = Gender.Woman;
        }

        [Given(@"(.*) lives at '(.*)'")]
        public void GivenPersonLivesAt(Person person, string address)
        {
            person.Address = address;
        }

        [When(@"(.*) move in together at '(.*)'")]
        public void WhenPersonsMoveInTogetherAt(Person[] persons, string newAddress)
        {
            Person.MoveInTogether(newAddress, persons);
        }

        [Then(@"(.*) his address is '(.*)'")]
        [Then(@"(.*) her address is '(.*)'")]
        [Then(@"(.*) address is '(.*)'")]
        public void ThenPersonsAddressIs(Person person, string expectedAddress)
        {
            Assert.AreEqual(expectedAddress, person.Address, $"Unexpected address for {person.Name}");
        }
    }
}
