using Reqnroll.Assist;
using ReqnrollParsableValueRetrieverAndComparer.Shared;

namespace ReqnrollParsableValueRetrieverAndComparer.Init
{
    /// <summary>
    /// Value Retriever that can be used by DataTable Helpers to convert a temperature to type <see cref="Temperature"/>.
    /// </summary>
    internal class TemperatureValueRetriever : IValueRetriever
    {
        /// <summary>
        /// Checks if the value can be retrieved as a <see cref="Temperature"/> by this retriever.
        /// </summary>
        /// <param name="keyValuePair">The column name and value. For example: "Maximum Temperature" and "21 °C".</param>
        /// <param name="targetType">The type that is created. For example <see cref="WeatherForecast"/>.</param>
        /// <param name="propertyType">The type of the property for which the value is retrieved. For example <see cref="Temperature"/>.</param>
        /// <returns>True when a temperature value is retrieved, else false.</returns>
        public bool CanRetrieve(KeyValuePair<string, string> keyValuePair, Type targetType, Type propertyType)
        {
            return propertyType == typeof(Temperature) && Temperature.TryParse(keyValuePair.Value, null, out _);
        }

        /// <summary>
        /// Retrieves the value as a <see cref="Temperature"/>.
        /// </summary>
        /// <param name="keyValuePair">The column name and value. For example: "Maximum Temperature" and "21 °C".</param>
        /// <param name="targetType">The type that is created. For example <see cref="WeatherForecast"/>.</param>
        /// <param name="propertyType">The type of the property for which the value is retrieved. For example <see cref="Temperature"/>.</param>
        /// <returns>The value as a <see cref="Temperature"/>.</returns>
        public object Retrieve(KeyValuePair<string, string> keyValuePair, Type targetType, Type propertyType)
        {
            return Temperature.Parse(keyValuePair.Value, null);
        }
    }
}
