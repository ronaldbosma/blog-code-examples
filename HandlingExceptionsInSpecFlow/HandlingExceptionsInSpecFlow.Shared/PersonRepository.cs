using System.Collections.Generic;
using System.Threading.Tasks;

namespace HandlingExceptionsInSpecFlow.Shared
{
    public class PersonRepository
    {
        private readonly HashSet<string> _people = new HashSet<string>();

        public void AddPerson(string name)
        {
            // For demo purposes we only store the name.
            _people.Add(name);
        }

        public string GetPersonByName(string name)
        {
            // For demo purposes we only check if de name is stored and return the name if it is stored.
            if (_people.Contains(name))
            {
                return name;
            }
            throw new PersonNotFoundException(name);
        }

        public Task<string> GetPersonByNameAsync(string name)
        {
            // For demo purposes we only check if de name is stored and return the name if it is stored.
            if (_people.Contains(name))
            {
                return Task.FromResult(name);
            }
            throw new PersonNotFoundException(name);
        }

        public void Clear()
        {
            _people.Clear();
        }
    }
}
