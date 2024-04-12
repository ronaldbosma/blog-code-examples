using System.Globalization;
using Reqnroll.Assist;

namespace ReqnrollParsableValueRetrieverAndComparer.GenericTypes
{
    /// <summary>
    /// Generic Value Comparer that can be used by DataTable Helpers to compare a value of type that implements <see cref="IParsable{T}"/>.
    /// </summary>
    /// <typeparam name="T">The type to compare.</typeparam>
    internal class ParsableValueComparer<T> : IValueComparer where T : IParsable<T>
    {
        /// <summary>
        /// Checks if the value can be compared by this comparer.
        /// </summary>
        /// <param name="actualValue">The actual value to be compared.</param>
        /// <returns>True if the value implements <see cref="IParsable{T}"/>, else false.</returns>
        public bool CanCompare(object actualValue)
        {
            return actualValue is IParsable<T>;
        }

        /// <summary>
        /// Compares the expected value with the actual value.
        /// </summary>
        public bool Compare(string expectedValue, object actualValue)
        {
            var isParsed = T.TryParse(expectedValue, CultureInfo.CurrentCulture, out T? expectedObject);
            return isParsed && actualValue.Equals(expectedObject);
        }
    }
}
