using TechTalk.SpecFlow.Assist.Attributes;

namespace TransformSpecFlowTableColumn.UseValueRetriever
{
    internal class WeatherForecast
    {
        public DateTime Date { get; set; }

        [TableAliases("Location")]
        public int LocationId { get; set; }

        public int Temperature { get; set; }
    }
}
