namespace MSTest.AreEquivalent.Models
{
    internal class AddressInternal
    {
        public required string Street { get; set; }

        public required string City { get; set; }

        public required string State { get; set; }

        public required string ZipCode { get; set; }

        public AddressInternal CreateCopy()
        {
            return new AddressInternal
            {
                Street = Street,
                City = City,
                State = State,
                ZipCode = ZipCode
            };
        }

        public AddressExternal MapToExternal()
        {
            return new AddressExternal
            {
                Street = Street,
                City = City,
                State = State,
                ZipCode = ZipCode
            };
        }
    }
}
