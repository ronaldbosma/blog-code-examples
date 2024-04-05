using TechTalk.SpecFlow;

namespace TransformSpecFlowTableColumn.TransformColumn
{
    internal static class TableExtensions
    {
        /// <summary>
        /// Transforms the Location column with location names into a LocationId column with location ids.
        /// </summary>
        public static Table TransformLocationNameToId(this Table table)
        {
            return table.TransformColumn("Location", "LocationId", (locationName) => locationName.LocationToId().ToString());
        }

        /// <summary>
        /// Renames the column <paramref name="oldColumn"/> to <paramref name="newColum"/> 
        /// and applies the <paramref name="transform"/> function to each value in the column.
        /// </summary>
        public static Table TransformColumn(this Table table, string oldColumn, string newColum, Func<string, string> transform)
        {
            if (table.ContainsColumn(oldColumn))
            {
                table.RenameColumn(oldColumn, newColum);

                foreach (var row in table.Rows)
                {
                    row[newColum] = transform(row[newColum]);
                }
            }

            return table;
        }
    }
}
