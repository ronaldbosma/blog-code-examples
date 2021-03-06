﻿using System.Threading.Tasks;
using HandlingExceptionsInSpecFlow.Shared;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace HandlingExceptionsInSpecFlow
{
    [Binding]
    internal class PersonSteps
    {
        private readonly PersonRepository _people = new PersonRepository();
        private string _actualName;

        private readonly ErrorDriver _errorDriver;

        public PersonSteps(ErrorDriver errorDriver)
        {
            _errorDriver = errorDriver;
        }

        [Given(@"the person '(.*)' is registered")]
        public void GivenThePersonIsRegistered(string name)
        {
            _people.AddPerson(name);
        }

        [Given(@"no person is registered")]
        public void GivenNoPersonIsRegistered()
        {
            _people.Clear();
        }

        [When(@"I retrieve the person '(.*)'")]
        public void WhenIRetrieveThePerson(string name)
        {
            _errorDriver.TryExecute(() =>
                _actualName = _people.GetPersonByName(name)
            );
        }

        [When(@"I retrieve the person '(.*)' async")]
        public async Task WhenIRetrieveThePersonAsync(string name)
        {
            await _errorDriver.TryExecuteAsync(async () =>
                _actualName = await _people.GetPersonByNameAsync(name)
            );
        }

        [Then(@"the person '(.*)' is returned")]
        public void ThenThePersonIsReturned(string expectedName)
        {
            Assert.IsNotNull(_actualName, "No person retrieved");
            Assert.AreEqual(expectedName, _actualName);
        }
    }
}
