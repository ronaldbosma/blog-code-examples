using System.Globalization;
using Reqnroll.Assist;

namespace ReqnrollParsableValueRetrieverAndComparer.Reflection
{
    /// <summary>
    /// Generic Value Retriever that can be used by Table Assist Helpers to convert a string to <see cref="IParsable{TSelf}"/>.
    /// </summary>
    internal class ParsableValueRetriever : IValueRetriever
    {
        /// <summary>
        /// Checks if <paramref name="propertyType"/> implements <see cref="IParsable{TSelf}"/> and 
        /// the value can be parsed with <see cref="IParsable{TSelf}"/>.
        /// </summary>
        /// <param name="keyValuePair">The column name and value. For example: "Maximum Temperature" and "21 °C".</param>
        /// <param name="targetType">The type that is created. For example <see cref="WeatherForecast"/>.</param>
        /// <param name="propertyType">The type of the property for which the value is retrieved. For example <see cref="Temperature"/>.</param>
        /// <returns>True when the value can be parsed to <paramref name="propertyType"/>, else false.</returns>
        public bool CanRetrieve(KeyValuePair<string, string> keyValuePair, Type targetType, Type propertyType)
        {
            return GenericParsableParser.ImplementsSupportedIParsable(propertyType) &&
                   GenericParsableParser.TryParse(propertyType, keyValuePair.Value, null, out _);
        }

        /// <summary>
        /// Retrieves the value as a TSelf of <see cref="IParsable{TSelf}"/>.
        /// </summary>
        /// <param name="keyValuePair">The column name and value. For example: "Maximum Temperature" and "21 °C".</param>
        /// <param name="targetType">The type that is created. For example <see cref="WeatherForecast"/>.</param>
        /// <param name="propertyType">The type of the property for which the value is retrieved. This should implement <see cref="IParsable{TSelf}"/>. For example <see cref="Temperature"/>.</param>
        /// <returns>The parsed value as TSelf.</returns>
        public object Retrieve(KeyValuePair<string, string> keyValuePair, Type targetType, Type propertyType)
        {
            return GenericParsableParser.Parse(propertyType, keyValuePair.Value, CultureInfo.CurrentCulture);
        }
    }
}
