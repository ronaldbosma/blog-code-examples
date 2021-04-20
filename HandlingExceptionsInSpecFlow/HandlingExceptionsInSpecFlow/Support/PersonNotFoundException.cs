using System;

namespace HandlingExceptionsInSpecFlow.Support
{
    public class PersonNotFoundException : Exception
    {
        public PersonNotFoundException(string name)
            : base($"Person with name {name} not found")
        {
        }
    }
}
