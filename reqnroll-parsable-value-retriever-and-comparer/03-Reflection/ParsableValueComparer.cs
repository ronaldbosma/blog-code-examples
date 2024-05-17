using System.Globalization;
using Reqnroll.Assist;

namespace ReqnrollParsableValueRetrieverAndComparer.Reflection
{
    /// <summary>
    /// Generic Value Comparer that can be used by Table Assist Helpers to compare a value of a type that implements <see cref="IParsable{TSelf}"/>.
    /// </summary>
    internal class ParsableValueComparer : IValueComparer
    {
        /// <summary>
        /// Checks if the value can be compared by this comparer.
        /// </summary>
        /// <param name="actualValue">The actual value to be compared.</param>
        /// <returns>True if the value can be compared, else false.</returns>
        public bool CanCompare(object actualValue)
        {
            return actualValue != null && GenericParsableParser.ImplementsSupportedIParsable(actualValue.GetType());
        }

        /// <summary>
        /// Compares the expected value with the actual value.
        /// </summary>
        public bool Compare(string expectedValue, object actualValue)
        {
            var isParsed = GenericParsableParser.TryParse(actualValue.GetType(), expectedValue, CultureInfo.CurrentCulture, out object? expectedObject);
            return isParsed && actualValue.Equals(expectedObject);
        }
    }
}
