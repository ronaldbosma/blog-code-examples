using TechTalk.SpecFlow.Assist.Attributes;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.UseValueRetriever
{
    public class WeatherForecastWithTableAlias : IWeatherForecast
    {
        public DateTime Date { get; set; }

        [TableAliases("Location")]
        public int LocationId { get; set; }

        public int Temperature { get; set; }
    }
}
