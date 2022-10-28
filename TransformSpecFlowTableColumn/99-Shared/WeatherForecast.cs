namespace TransformSpecFlowTableColumn.Shared
{
    public class WeatherForecast : IWeatherForecast
    {
        public DateTime Date { get; set; }

        public int LocationId { get; set; }

        public int Temperature { get; set; }
    }
}
