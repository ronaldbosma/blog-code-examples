using System.Globalization;
using Reqnroll.Assist;

namespace ReqnrollParsableValueRetrieverAndComparer.GenericTypes
{
    /// <summary>
    /// Generic Value Retriever that can be used by DataTable Helpers to convert a string to <see cref="IParsable{T}"/>.
    /// </summary>
    /// <typeparam name="T">The type to retrieve.</typeparam>
    internal class ParsableValueRetriever<T> : IValueRetriever where T : IParsable<T>
    {
        /// <summary>
        /// Checks if <paramref name="propertyType"/> implements <see cref="IParsable{T}"/> and 
        /// the value can be parsed with <see cref="IParsable{T}"/>.
        /// </summary>
        /// <param name="keyValuePair">The column name and value. For example: "Maximum Temperature" and "21 °C".</param>
        /// <param name="targetType">The type that is created. For example <see cref="WeatherForecast"/>.</param>
        /// <param name="propertyType">The type of the property for which the value is retrieved. For example <see cref="Temperature"/>.</param>
        /// <returns>True when the value can be parsed to <paramref name="propertyType"/>, else false.</returns>
        public bool CanRetrieve(KeyValuePair<string, string> keyValuePair, Type targetType, Type propertyType)
        {
            return typeof(IParsable<T>).IsAssignableFrom(propertyType) &&
                   T.TryParse(keyValuePair.Value, CultureInfo.CurrentCulture, out _);
        }

        /// <summary>
        /// Retrieves the value as a T of <see cref="IParsable{T}"/>.
        /// </summary>
        /// <param name="keyValuePair">The column name and value. For example: "Maximum Temperature" and "21 °C".</param>
        /// <param name="targetType">The type that is created. For example <see cref="WeatherForecast"/>.</param>
        /// <param name="propertyType">The type of the property for which the value is retrieved. This should implement <see cref="IParsable{T}"/>. For example <see cref="Temperature"/>.</param>
        /// <returns>The parsed value as T.</returns>
        public object Retrieve(KeyValuePair<string, string> keyValuePair, Type targetType, Type propertyType)
        {
            return T.Parse(keyValuePair.Value, CultureInfo.CurrentCulture);
        }
    }
}
