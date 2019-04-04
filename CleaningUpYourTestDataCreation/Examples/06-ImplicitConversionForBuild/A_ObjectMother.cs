namespace Examples._06_ImplicitConversionForBuild
{
    class A
    {
        public static PersonBuilder Person => new PersonBuilder();

        public static PersonBuilder Man => Person.IsMan();
    }
}
