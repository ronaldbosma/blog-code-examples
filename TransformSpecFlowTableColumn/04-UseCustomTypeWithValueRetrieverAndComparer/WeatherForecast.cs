using TechTalk.SpecFlow.Assist.Attributes;

namespace TransformSpecFlowTableColumn.UseCustomTypeWithValueRetrieverAndComparer
{
    internal class WeatherForecast
    {
        public DateTime Date { get; set; }

        [TableAliases("Location")]
        public LocationId LocationId { get; set; }

        public int Temperature { get; set; }
    }

    public record struct LocationId(int locationId);
}
