namespace HandlingTechnicalIdsInGherkinWithSpecFlow.Shared
{
    public class Person
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string Address { get; set; }

        public void Move(string newAddress)
        {
            Address = newAddress;
        }
    }
}
