﻿namespace TransformSpecFlowTableColumn.TransformColumn
{
    public class WeatherForecastRepository
    {
        private List<WeatherForecast> _weatherForecasts = new();

        public void Register(IEnumerable<WeatherForecast> weatherForecasts)
        {
            _weatherForecasts.AddRange(weatherForecasts);
        }

        public WeatherForecast? GetByDateAndLocation(DateTime date, int locationId)
        {
            return _weatherForecasts.SingleOrDefault(wf => wf.Date == date && wf.LocationId == locationId);
        }
    }
}
