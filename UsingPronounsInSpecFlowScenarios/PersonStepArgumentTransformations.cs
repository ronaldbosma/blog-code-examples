using System.Collections.Generic;
using TechTalk.SpecFlow;

namespace UsingPronounsInSpecFlowScenarios
{
    [Binding]
    class PersonStepArgumentTransformations
    {
        private Dictionary<string, Person> _persons = new Dictionary<string, Person>();

        [StepArgumentTransformation("(.*)")]
        public Person ConvertNameToPerson(string name)
        {
            if (!_persons.ContainsKey(name))
            {
                _persons.Add(name, new Person { Name = name });
            }

            return _persons[name];
        }
    }
}
