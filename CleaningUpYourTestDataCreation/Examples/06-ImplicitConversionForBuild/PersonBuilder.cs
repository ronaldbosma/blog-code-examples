using Examples.Models;

namespace Examples._06_ImplicitConversionForBuild
{
    class PersonBuilder
    {
        private string _name;
        private Gender _gender;
        private Address _address;

        public PersonBuilder Called(string name)
        {
            _name = name;
            return this;
        }

        public PersonBuilder IsMan()
        {
            _gender = Gender.Man;
            return this;
        }

        public PersonBuilder LivingAt(string address)
        {
            return LivingAt(new AddressBuilder().WithAddress(address));
        }

        public PersonBuilder LivingAt(Address address)
        {
            _address = address;
            return this;
        }

        public static implicit operator Person(PersonBuilder builder)
        {
            return builder.Build();
        }

        public Person Build()
        {
            return new Person
            {
                Name = _name,
                Gender = _gender,
                Address = _address
            };
        }
    }
}
