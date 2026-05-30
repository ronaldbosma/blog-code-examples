namespace MSTest.AreEquivalent.Models
{
    internal class PersonInternal
    {
        public required string FirstName { get; set; }

        public required string LastName { get; set; }

        public required int Age { get; set; }

        public required AddressInternal Address { get; set; }

        public PersonExternal MapToExternal()
        {
            return new PersonExternal
            {
                FirstName = FirstName,
                LastName = LastName,
                Age = Age,
                Address = Address.MapToExternal()
            };
        }
    }
}
