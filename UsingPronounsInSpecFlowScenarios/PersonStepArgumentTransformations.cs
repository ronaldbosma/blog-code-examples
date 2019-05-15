using System;
using System.Collections.Generic;
using TechTalk.SpecFlow;

namespace UsingPronounsInSpecFlowScenarios
{
    [Binding]
    class PersonStepArgumentTransformations
    {
        private readonly Dictionary<string, Person> _persons = new Dictionary<string, Person>();
        private Person _lastCreatedPerson;
        private Person _he;
        private Person _she;

        [StepArgumentTransformation("(he|his)")]
        public Person ConvertHeToPerson(string malePronoun)
        {
            if (_he != null)
            {
                return _he;
            }
            else if (_lastCreatedPerson != null)
            {
                _he = _lastCreatedPerson;
                _lastCreatedPerson = null;
                return _he;
            }
            else
            {
                throw new InvalidOperationException($"Unable to convert '{malePronoun}' to person. No available person was found.");
            }
        }

        [StepArgumentTransformation("(she|her)")]
        public Person ConvertSheToPerson(string femalePronoun)
        {
            if (_she != null)
            {
                return _she;
            }
            else if (_lastCreatedPerson != null)
            {
                _she = _lastCreatedPerson;
                _lastCreatedPerson = null;
                return _she;
            }
            else
            {
                throw new InvalidOperationException($"Unable to convert '{femalePronoun}' to person. No available person was found.");
            }
        }

        [StepArgumentTransformation("'(.*)'")]
        public Person ConvertNameToPerson(string name)
        {
            if (!_persons.ContainsKey(name))
            {
                _persons.Add(name, new Person { Name = name });
                _lastCreatedPerson = _persons[name];
            }

            return _persons[name];
        }
    }
}
