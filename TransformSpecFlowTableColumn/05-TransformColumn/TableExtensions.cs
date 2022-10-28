using TechTalk.SpecFlow;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.TransformColumn
{
    internal static class TableExtensions
    {
        public static Table TransformLocationNameToId(this Table table)
        {
            return table.TransformColumn("Location", "LocationId", (s) => s.LocationToId().ToString());
        }

        public static Table TransformColumn(this Table table, string oldColumn, string newColum, Func<string, string> transform)
        {
            table.RenameColumn(oldColumn, newColum);

            foreach (var row in table.Rows)
            {
                row[newColum] = transform(row[newColum]);
            }

            return table;
        }
    }
}
