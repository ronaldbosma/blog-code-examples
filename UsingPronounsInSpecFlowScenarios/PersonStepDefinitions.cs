using System.Collections.Generic;
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

        [When(@"(.*) and (.*) move in together at '(.*)'")]
        public void WhenPerson1AndPerson2MoveInTogetherAt(Person person1, Person person2, string newAddress)
        {
            Person.MoveInTogether(person1, person2, newAddress);
        }

        [Then(@"(.*) his address is '(.*)'")]
        [Then(@"(.*) her address is '(.*)'")]
        public void ThenHisAddressIs(Person person, string expectedAddress)
        {
            Assert.AreEqual(expectedAddress, person.Address, $"Unexpected address for {person.Name}");
        }
    }
}
