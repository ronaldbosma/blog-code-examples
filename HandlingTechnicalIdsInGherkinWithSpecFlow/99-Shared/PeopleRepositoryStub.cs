using System.Collections.Generic;

namespace HandlingTechnicalIdsInGherkinWithSpecFlow.Shared
{
    public class PeopleRepositoryStub : IPeopleRepository
    {
        private readonly IDictionary<int, Person> _people = new Dictionary<int, Person>();

        public Person GetById(int id)
        {
            return _people[id];
        }

        public void AddRange(IEnumerable<Person> people)
        {
            foreach (var person in people)
            {
                _people.Add(person.Id, person);
            }
        }
    }
}
