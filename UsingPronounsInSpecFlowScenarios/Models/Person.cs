namespace UsingPronounsInSpecFlowScenarios.Models
{
    class Person
    {
        public string Name { get; set; }

        public Gender Gender { get; set; }

        public string Address { get; set; }

        public static void MoveInTogether(string newAddress, params Person[] persons)
        {
            foreach (var person in persons)
            {
                person.Address = newAddress;
            }
        }
    }
}
