namespace MSTest.AreEquivalent.Models
{
    internal class PersonExternal
    {
        public PersonExternal(string firstName, string lastName, int age, AddressExternal address)
        {
            FirstName = firstName;
            LastName = lastName;
            Age = age;
            Address = address;
        }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public int Age { get; set; }

        public AddressExternal Address { get; set; }
    }
}
