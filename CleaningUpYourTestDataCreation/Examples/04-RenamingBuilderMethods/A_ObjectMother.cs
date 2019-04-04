namespace Examples._04_RenamingBuilderMethods
{
    class A
    {
        public static PersonBuilder Person => new PersonBuilder();

        public static PersonBuilder Man => Person.IsMan();
    }
}
