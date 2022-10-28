namespace TransformSpecFlowTableColumn.Shared
{
    public static class StringExtensions
    {
        public static int LocationToId(this string location)
        {
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
