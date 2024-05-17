namespace ReqnrollParsableValueRetrieverAndComparer.Shared
{
    public class WeatherForecast
    {
        public DateOnly Date { get; set; }

        public Temperature MinimumTemperature { get; set; } = null!;

        public Temperature? MaximumTemperature { get; set; }
    }
}
