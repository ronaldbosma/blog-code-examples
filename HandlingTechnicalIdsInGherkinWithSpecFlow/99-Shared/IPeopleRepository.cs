namespace HandlingTechnicalIdsInGherkinWithSpecFlow.Shared
{
    public interface IPeopleRepository
    {
        Person GetById(int id);
    }
}
