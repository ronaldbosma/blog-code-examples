﻿namespace TransformSpecFlowTableColumn.Init
{
    internal static class StringExtensions
    {
        public static int LocationToId(this string location)
        {
            return Math.Abs(location.GetHashCode());
        }
    }
}
