namespace Examples._05_RefactorAddressBuilding
{
    class A
    {
        public static PersonBuilder Person => new PersonBuilder();

        public static PersonBuilder Man => Person.IsMan();
    }
}
