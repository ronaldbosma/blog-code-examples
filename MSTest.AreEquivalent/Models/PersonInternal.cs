namespace MSTest.AreEquivalent.Models
{
    internal record PersonInternal
    {
        public required string FirstName { get; init; }

        public required string LastName { get; init; }

        public required int Age { get; init; }

        public required AddressInternal Address { get; init; }
    }
}
