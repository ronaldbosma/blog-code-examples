namespace TransformSpecFlowTableColumn.Shared
{
    public static class StringExtensions
    {
        public static int NameToId(this string name)
        {
            return Math.Abs(name.GetHashCode());
        }
    }
}
