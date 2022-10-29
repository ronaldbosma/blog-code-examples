namespace TransformSpecFlowTableColumn.UseValueRetriever
{
    public static class StringExtensions
    {
        public static int LocationToId(this string location)
        {
            // The GetHashCode method generates a different id per test run execution.
            // Because I've added the id in the Gherkin scenario it needs to be the same value every time.

            switch (location)
            {
                case "Amsterdam": return 1;
                case "London": return 2;
                case "Madrid": return 3;
                default: throw new ArgumentException("Unknown location", nameof(location));
            }
        }
    }
}
