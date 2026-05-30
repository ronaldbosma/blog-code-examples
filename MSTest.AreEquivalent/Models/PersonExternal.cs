namespace MSTest.AreEquivalent.Models
{
    internal record PersonExternal
    {
        public required string FirstName { get; init; }

        public required string LastName { get; init; }

        public required int Age { get; init; }

        public required AddressExternal Address { get; init; }
    }
}
