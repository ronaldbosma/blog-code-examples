namespace TransformSpecFlowTableColumn.UseCustomTypeWithValueRetrieverAndComparer
{
    internal class WeatherForecastWithCustomLocationIdTypeRepository
    {
        private List<WeatherForecastWithCustomLocationIdType> _weatherForecasts = new();

        public void Register(IEnumerable<WeatherForecastWithCustomLocationIdType> weatherForecasts)
        {
            _weatherForecasts.AddRange(weatherForecasts);
        }

        public IEnumerable<WeatherForecastWithCustomLocationIdType> GetByLocation(LocationId locationId)
        {
            return _weatherForecasts.Where(wf => wf.LocationId == locationId);
        }
    }
}
