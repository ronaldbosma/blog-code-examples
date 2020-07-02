using System;

namespace HandlingTechnicalIdsInGherkinWithSpecFlow.Shared
{
    public interface IPeopleRepository
    {
        Person GetById(Guid id);
    }
}
