namespace MSTest.AreEquivalent.Models
{
    internal class AddressInternal
    {
        public AddressInternal(string street, string city, string state, string zipCode)
        {
            Street = street;
            City = city;
            State = state;
            ZipCode = zipCode;
        }

        public string Street { get; set; }

        public string City { get; set; }

        public string State { get; set; }

        public string ZipCode { get; set; }

        public AddressInternal CreateCopy()
        {
            return new AddressInternal(Street, City, State, ZipCode);
        }

        public AddressExternal MapToExternal()
        {
            return new AddressExternal(Street, City, State, ZipCode);
        }
    }
}
