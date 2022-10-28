using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.TransformColumn
{
    [Binding]
    internal class Steps
    {
        private readonly WeatherForecastRepository _repository = new ();
        private IWeatherForecast? _actualWeatherForecast;

        [Given(@"the weather forecasts")]
        public void GivenTheWeatherForecasts(Table table)
        {
            var weatherForecasts = table.TransformColumn("Location", "LocationId", (s) => s.LocationToId().ToString())
                                        .CreateSet<WeatherForecast>();

            _repository.Register(weatherForecasts);
        }

        [When(@"the weather forecast for '([^']*)' on '([^']*)' is retrieved")]
        public void WhenTheWeatherForecastForOnIsRetrieved(string location, DateTime date)
        {
            int locationId = location.LocationToId();
            _actualWeatherForecast = _repository.GetByDateAndLocation(date, locationId);
        }

        [Then(@"the following weather forecast is returned")]
        public void ThenTheFollowingWeatherForecastIsReturned(Table table)
        {
            table.TransformColumn("Location", "LocationId", (s) => s.LocationToId().ToString())
                 .CompareToInstance(_actualWeatherForecast);
        }
    }
}
