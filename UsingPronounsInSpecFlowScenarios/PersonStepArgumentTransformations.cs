using System;
using System.Linq;
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
        public Person ConvertHeToPerson(string pronoun)
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
                throw new InvalidOperationException($"Unable to convert '{pronoun}' to person. No available person was found.");
            }
        }

        [StepArgumentTransformation("(she|her)")]
        public Person ConvertSheToPerson(string pronoun)
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
                throw new InvalidOperationException($"Unable to convert '{pronoun}' to person. No available person was found.");
            }
        }

        [StepArgumentTransformation("(they|their)")]
        public Person[] ConvertTheyToPersons(string pronoun)
        {
            if (_persons.Count < 2)
            {
                throw new InvalidOperationException($"Unable to convert '{pronoun}' to persons. There should be atleast 2 persons.");
            }

            return _persons.Values.ToArray();
        }

        /// <summary>
        /// This method using Step Argument Transformation chaning.
        /// Because the method is expecting two input parameters of type <see cref="Person"/>
        /// SpecFlow will first call <see cref="ConvertNameToPerson"/> for each name to create the <see cref="Person"/>.
        /// Then this method is called to combine the persons.
        /// </summary>
        [StepArgumentTransformation("(.*) and (.*)")]
        public Person[] ConvertTwoPersonsIntoCollection(Person person1, Person person2)
        {
            return new Person[] { person1, person2 };
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
