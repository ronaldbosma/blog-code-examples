namespace MSTest.AreEquivalent.Models
{
    internal record AddressInternal
    {
        public required string Street { get; init; }

        public required string City { get; init; }

        public required string State { get; init; }

        public required string ZipCode { get; init; }
    }
}
