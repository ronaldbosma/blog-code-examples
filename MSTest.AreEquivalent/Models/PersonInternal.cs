namespace MSTest.AreEquivalent.Models
{
    internal class PersonInternal
    {
        public PersonInternal(string firstName, string lastName, int age, AddressInternal address)
        {
            FirstName = firstName;
            LastName = lastName;
            Age = age;
            Address = address;
        }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public int Age { get; set; }

        public AddressInternal Address { get; set; }

        public PersonInternal CreateCopy()
        {
            return new PersonInternal(FirstName, LastName, Age, Address.CreateCopy());
        }

        public PersonExternal MapToExternal()
        {
            return new PersonExternal(FirstName, LastName, Age, Address.MapToExternal());
        }
    }
}
