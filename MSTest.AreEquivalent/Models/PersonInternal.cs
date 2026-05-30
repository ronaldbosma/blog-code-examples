namespace MSTest.AreEquivalent.Models
{
    internal class PersonInternal
    {
        public required string FirstName { get; set; }

        public required string LastName { get; set; }

        public required int Age { get; set; }

        public required AddressInternal Address { get; set; }
    }
}
