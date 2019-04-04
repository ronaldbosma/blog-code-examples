namespace Examples._03_RefactorObjectMother
{
    class A
    {
        public static PersonBuilder Person => new PersonBuilder();

        public static PersonBuilder Man => Person.IsMan();
    }
}
