using System;
using System.Collections.Generic;

namespace HandlingTechnicalIdsInGherkinWithSpecFlow.Shared
{
    public class PeopleRepositoryStub : IPeopleRepository
    {
        private readonly IDictionary<Guid, Person> _people = new Dictionary<Guid, Person>();

        public Person GetById(Guid id)
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
