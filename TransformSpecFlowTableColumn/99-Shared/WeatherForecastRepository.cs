namespace TransformSpecFlowTableColumn.Shared
{
    public class WeatherForecastRepository
    {
        private List<IWeatherForecast> _weatherForecasts = new();

        public void Register(IEnumerable<IWeatherForecast> weatherForecasts)
        {
            _weatherForecasts.AddRange(weatherForecasts);
        }

        public IEnumerable<IWeatherForecast> GetByLocation(int locationId)
        {
            return _weatherForecasts.Where(wf => wf.LocationId == locationId);
        }
    }
}
