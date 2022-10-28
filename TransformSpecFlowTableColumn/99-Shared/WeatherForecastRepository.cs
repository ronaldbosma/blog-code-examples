namespace TransformSpecFlowTableColumn.Shared
{
    public class WeatherForecastRepository
    {
        private List<WeatherForecast> _weatherForecasts = new();

        public void Register(IEnumerable<WeatherForecast> weatherForecasts)
        {
            _weatherForecasts.AddRange(weatherForecasts);
        }

        public IEnumerable<WeatherForecast> GetByLocation(int locationId)
        {
            return _weatherForecasts.Where(wf => wf.LocationId == locationId);
        }
    }
}
