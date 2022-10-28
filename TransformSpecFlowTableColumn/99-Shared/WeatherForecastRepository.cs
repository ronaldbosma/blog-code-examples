namespace TransformSpecFlowTableColumn.Shared
{
    public class WeatherForecastRepository
    {
        private List<IWeatherForecast> _weatherForecasts = new();

        public void Register(IEnumerable<IWeatherForecast> weatherForecasts)
        {
            _weatherForecasts.AddRange(weatherForecasts);
        }

        public IWeatherForecast? GetByDateAndLocation(DateTime date, int locationId)
        {
            return _weatherForecasts.SingleOrDefault(wf => wf.Date == date && wf.LocationId == locationId);
        }
    }
}
