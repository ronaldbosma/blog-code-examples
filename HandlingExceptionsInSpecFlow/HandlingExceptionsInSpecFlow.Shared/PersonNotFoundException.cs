using System;

namespace HandlingExceptionsInSpecFlow.Shared
{
    public class PersonNotFoundException : Exception
    {
        public PersonNotFoundException(string name)
            : base($"Person with name {name} not found")
        {
        }
    }
}
