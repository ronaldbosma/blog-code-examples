using Reqnroll.Assist;

namespace ReqnrollParsableValueRetrieverAndComparer.Init
{
    /// <summary>
    /// Value Comparer that can be used by DataTable Helpers to compare a value of type <see cref="DateOnly"/>.
    /// </summary>
    internal class DateOnlyValueComparer : IValueComparer
    {
        /// <summary>
        /// Checks if the value can be compared by this comparer.
        /// </summary>
        /// <param name="actualValue">The actual value to be compared.</param>
        /// <returns>True if the value can be compared, else false.</returns>
        public bool CanCompare(object actualValue)
        {
            return actualValue is DateOnly;
        }

        /// <summary>
        /// Compares the expected value with the actual value.
        /// </summary>
        public bool Compare(string expectedValue, object actualValue)
        {
            var expectedDate = DateOnly.Parse(expectedValue);
            var actualDate = (DateOnly)actualValue;

            return expectedDate == actualDate;
        }
    }
}
