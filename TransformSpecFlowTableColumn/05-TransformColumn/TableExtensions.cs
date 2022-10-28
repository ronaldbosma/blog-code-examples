﻿using TechTalk.SpecFlow;

namespace TransformSpecFlowTableColumn.TransformColumn
{
    internal static class TableExtensions
    {
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
