using Reqnroll.Assist;
using ReqnrollParsableValueRetrieverAndComparer.Shared;

namespace ReqnrollParsableValueRetrieverAndComparer.Init
{
    /// <summary>
    /// Value Comparer that can be used by DataTable Helpers to compare a value of type <see cref="Temperature"/>.
    /// </summary>
    internal class TemperatureValueComparer : IValueComparer
    {
        /// <summary>
        /// Checks if the value can be compared by this comparer.
        /// </summary>
        /// <param name="actualValue">The actual value to be compared.</param>
        /// <returns>True if the value can be compared, else false.</returns>
        public bool CanCompare(object actualValue)
        {
            return actualValue is Temperature;
        }

        /// <summary>
        /// Compares the expected value with the actual value.
        /// </summary>
        public bool Compare(string expectedValue, object actualValue)
        {
            var expectedTemperature = Temperature.Parse(expectedValue, null);
            var actualTemperature = (Temperature)actualValue;

            return expectedTemperature == actualTemperature;
        }
    }
}
