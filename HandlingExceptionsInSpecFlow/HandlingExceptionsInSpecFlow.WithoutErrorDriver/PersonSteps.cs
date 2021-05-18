﻿using System;
using System.Threading.Tasks;
using HandlingExceptionsInSpecFlow.Shared;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;

namespace HandlingExceptionsInSpecFlow
{
    [Binding]
    class PersonPersonsSteps
    {
        private readonly PersonRepository _people = new PersonRepository();
        private string _actualName;
        private Exception _actualException;

        [Given(@"the person '(.*)' is registered")]
        public void GivenThePersonLivingAtIsRegistered(string name)
        {
            _people.AddPerson(name);
        }

        [Then(@"the person '(.*)' is returned")]
        public void ThenThePersonLivingAtIsReturned(string expectedName)
        {
            Assert.IsNotNull(_actualName, "No person retrieved");
            Assert.AreEqual(expectedName, _actualName);
        }

        [Given(@"no person is registered")]
        public void GivenNoPersonIsRegistered()
        {
            _people.Clear();
        }

        [When(@"I retrieve '(.*)'")]
        public void WhenIRetrieve(string name)
        {
            try
            {
                _actualName = _people.GetPersonByName(name);
            }
            catch (Exception ex)
            {
                _actualException = ex;
            }
        }

        [Then(@"the error '(.*)' should be raised")]
        public void ThenTheErrorShouldBeRaised(string expectedErrorMessage)
        {
            Assert.IsNotNull(_actualException, "No error was raised");
            Assert.AreEqual(expectedErrorMessage, _actualException.Message);
        }
    }
}