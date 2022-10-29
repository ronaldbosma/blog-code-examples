using TechTalk.SpecFlow.Assist;

namespace TransformSpecFlowTableColumn.UseCustomTypeWithValueRetrieverAndComparer
{
    /// <summary>
    /// Will convert a Location name to a LocationId when using CreateSet or CreateInstance.
    /// </summary>
    /// <seealso cref="https://docs.specflow.org/projects/specflow/en/latest/Extend/Value-Retriever.html"/>
    internal class LocationIdValueRetriever : IValueRetriever
    {
        public bool CanRetrieve(KeyValuePair<string, string> keyValuePair, Type targetType, Type propertyType)
        {
            return propertyType == typeof(LocationId);
        }

        public object Retrieve(KeyValuePair<string, string> keyValuePair, Type targetType, Type propertyType)
        {
            return new LocationId(keyValuePair.Value.LocationToId());
        }
    }
}
