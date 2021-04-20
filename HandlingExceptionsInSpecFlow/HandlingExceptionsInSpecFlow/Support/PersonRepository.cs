using System.Collections.Generic;
using System.Threading.Tasks;

namespace HandlingExceptionsInSpecFlow.Support
{
    internal class PersonRepository
    {
        private readonly HashSet<string> _people = new HashSet<string>();

        public void AddPerson(string name)
        {
            _people.Add(name);
        }

        public void Clear()
        {
            _people.Clear();
        }

        public string GetPersonByName(string name)
        {
            if (_people.Contains(name))
            {
                return name;
            }
            throw new PersonNotFoundException(name);
        }

        public Task<string> GetPersonByNameAsync(string name)
        {
            if (_people.Contains(name))
            {
                return Task.FromResult(name);
            }
            throw new PersonNotFoundException(name);
        }
    }
}
