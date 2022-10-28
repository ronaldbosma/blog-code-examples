using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.TransformColumn
{
    [Binding]
    internal class Steps
    {
        private readonly WeatherForecastRepository _repository = new ();
        private IEnumerable<IWeatherForecast>? _actualWeatherForecasts;

        [Given(@"the weather forecasts")]
        public void GivenTheWeatherForecasts(Table table)
        {
            var weatherForecasts = table.TransformColumn("Location", "LocationId", (s) => s.LocationToId().ToString())
                                        .CreateSet<WeatherForecast>();

            _repository.Register(weatherForecasts);
        }

        [When(@"the weather forecasts for '([^']*)' are retrieved")]
        public void WhenTheWeatherForecastsForAreRetrieved(string location)
        {
            int locationId = location.LocationToId();
            _actualWeatherForecasts = _repository.GetByLocation(locationId);
        }

        [Then(@"the following weather forecasts are returned")]
        public void ThenTheFollowingWeatherForecastsAreReturned(Table table)
        {
            table.TransformColumn("Location", "LocationId", (s) => s.LocationToId().ToString())
                 .CompareToSet(_actualWeatherForecasts);
        }
    }
}
