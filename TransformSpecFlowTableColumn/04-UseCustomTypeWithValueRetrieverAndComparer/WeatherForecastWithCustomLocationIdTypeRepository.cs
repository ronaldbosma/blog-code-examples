using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.UseCustomTypeWithValueRetrieverAndComparer
{
    internal class WeatherForecastWithCustomLocationIdTypeRepository
    {
        private List<WeatherForecastWithCustomLocationIdType> _weatherForecasts = new();

        public void Register(IEnumerable<WeatherForecastWithCustomLocationIdType> weatherForecasts)
        {
            _weatherForecasts.AddRange(weatherForecasts);
        }

        public WeatherForecastWithCustomLocationIdType? GetByDateAndLocation(DateTime date, LocationId locationId)
        {
            return _weatherForecasts.SingleOrDefault(wf => wf.Date == date && wf.LocationId == locationId);
        }
    }
}
