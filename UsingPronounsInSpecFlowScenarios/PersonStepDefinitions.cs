using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace UsingPronounsInSpecFlowScenarios
{
    [Binding]
    class PersonStepDefinitions
    {
        private Dictionary<string, Person> _persons = new Dictionary<string, Person>();

        [Given(@"a man called '(.*)'")]
        public void GivenAManCalled(string name)
        {
            _persons.Add(name, new Person
            {
                Name = name,
                Gender = Gender.Man
            });
        }

        [Given(@"a woman called '(.*)'")]
        public void GivenAWomanCalled(string name)
        {
            _persons.Add(name, new Person
            {
                Name = name,
                Gender = Gender.Woman
            });
        }

        [Given(@"'(.*)' lives at '(.*)'")]
        public void GivenPersonLivesAt(string name, string address)
        {
            var person = _persons[name];
            person.Address = address;
        }

        [When(@"'(.*)' and '(.*)' move in together at '(.*)'")]
        public void WhenPerson1AndPerson2MoveInTogetherAt(string name1, string name2, string newAddress)
        {
            var person1 = _persons[name1];
            var person2 = _persons[name2];

            Person.MoveInTogether(person1, person2, newAddress);
        }

        [Then(@"'(.*)' his address is '(.*)'")]
        [Then(@"'(.*)' her address is '(.*)'")]
        public void ThenHisAddressIs(string name, string expectedAddress)
        {
            var person = _persons[name];
            Assert.AreEqual(expectedAddress, person.Address, $"Unexpected address for {name}");
        }
    }
}
