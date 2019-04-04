using Examples.Models;

namespace Examples._06_ImplicitConversionForBuild
{
    class AddressBuilder
    {
        private string _addressLine1;
        private string _addressLine2;

        public AddressBuilder WithAddress(string addressLines)
        {
            string[] addressLinesArray = addressLines.Split(',');

            return WithAddressLine1(addressLinesArray[0])
              .WithAddressLine2(addressLinesArray[1].TrimStart());
        }

        public AddressBuilder WithAddressLine1(string addressLine1)
        {
            _addressLine1 = addressLine1;
            return this;
        }

        public AddressBuilder WithAddressLine2(string addressLine2)
        {
            _addressLine2 = addressLine2;
            return this;
        }

        public static implicit operator Address(AddressBuilder builder)
        {
            return builder.Build();
        }

        public Address Build()
        {
            return new Address
            {
                AddressLine1 = _addressLine1,
                AddressLine2 = _addressLine2,
                CountryCode = "GBR"
            };
        }
    }
}
