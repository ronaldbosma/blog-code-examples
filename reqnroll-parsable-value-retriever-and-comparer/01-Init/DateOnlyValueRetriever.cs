using Reqnroll.Assist;
using ReqnrollParsableValueRetrieverAndComparer.Shared;

namespace ReqnrollParsableValueRetrieverAndComparer.Init
{
    /// <summary>
    /// Value Retriever that can be used by DataTable Helpers to convert a value to type <see cref="DateOnly"/>.
    /// </summary>
    internal class DateOnlyValueRetriever : IValueRetriever
    {
        /// <summary>
        /// Checks if the value can be retrieved as <see cref="DateOnly"/> by this retriever.
        /// </summary>
        /// <param name="keyValuePair">The column name and value. For example: "Date" and "16 March 2022".</param>
        /// <param name="targetType">The type that is created. For example <see cref="WeatherForecast"/>.</param>
        /// <param name="propertyType">The type of the property for which the value is retrieved. For example <see cref="DateOnly"/>.</param>
        /// <returns>True when date only value is retrieved, else false.</returns>
        public bool CanRetrieve(KeyValuePair<string, string> keyValuePair, Type targetType, Type propertyType)
        {
            return propertyType == typeof(DateOnly) && DateOnly.TryParse(keyValuePair.Value, out _);
        }

        /// <summary>
        /// Retrieves the value as a <see cref="DateOnly"/>.
        /// </summary>
        /// <param name="keyValuePair">The column name and value. For example: "Date" and "16 March 2022".</param>
        /// <param name="targetType">The type that is created. For example <see cref="WeatherForecast"/>.</param>
        /// <param name="propertyType">The type of the property for which the value is retrieved. For example <see cref="DateOnly"/>.</param>
        /// <returns>The value as a <see cref="DateOnly"/>.</returns>
        public object Retrieve(KeyValuePair<string, string> keyValuePair, Type targetType, Type propertyType)
        {
            return DateOnly.Parse(keyValuePair.Value);
        }
    }
}
