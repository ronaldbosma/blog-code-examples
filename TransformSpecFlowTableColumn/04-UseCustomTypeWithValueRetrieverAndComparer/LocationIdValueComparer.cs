using TechTalk.SpecFlow.Assist;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.UseCustomTypeWithValueRetrieverAndComparer
{
    /// <summary>
    /// Will compare a location name to a location id of type <see cref="LocationId"/>.
    /// </summary>
    /// <seealso cref="https://docs.specflow.org/projects/specflow/en/latest/Extend/Value-Retriever.html"/>
    internal class LocationIdValueComparer : IValueComparer
    {
        public bool CanCompare(object actualValue)
        {
            return actualValue is LocationId;
        }

        public bool Compare(string expectedValue, object actualValue)
        {
            var expected = new LocationId(expectedValue.LocationToId());
            var actual = (LocationId)actualValue;

            return expected == actual;
        }
    }
}
