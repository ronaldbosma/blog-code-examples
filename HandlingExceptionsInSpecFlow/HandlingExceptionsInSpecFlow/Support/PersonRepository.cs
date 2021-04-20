using System.Collections.Generic;

namespace HandlingExceptionsInSpecFlow.Support
{
    internal class PersonRepository
    {
        private readonly Dictionary<string, Person> _people = new Dictionary<string, Person>();

        public void AddPerson(string name, string address)
        {
            _people.Add(name, new Person
            {
                Name = name,
                Address = address
            });
        }

        public void Clear()
        {
            _people.Clear();
        }

        public Person GetPersonByName(string name)
        {
            if (_people.ContainsKey(name))
            {
                return _people[name];
            }
            throw new PersonNotFoundException(name);
        }
    }
}
