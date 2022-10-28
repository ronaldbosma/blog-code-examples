using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.Init
{
    [Binding]
    internal class Steps
    {
        private readonly WeatherForecastRepository _repository = new ();
        private IEnumerable<WeatherForecast>? _actualWeatherForecasts;

        [Given(@"the weather forecasts")]
        public void GivenTheWeatherForecasts(Table table)
        {
            var weatherForecasts = table.CreateSet<WeatherForecast>();
            _repository.Register(weatherForecasts);
        }

        [When(@"the weather forecasts for (\d+) are retrieved")]
        public void WhenTheWeatherForecastsForAreRetrieved(int locationId)
        {
            _actualWeatherForecasts = _repository.GetByLocation(locationId);
        }

        [When(@"the weather forecasts for '([^']*)' are retrieved")]
        public void WhenTheWeatherForecastsForAreRetrieved(string location)
        {
            int locationId = location.NameToId();
            _actualWeatherForecasts = _repository.GetByLocation(locationId);
        }

        [Then(@"the following weather forecasts are returned")]
        public void ThenTheFollowingWeatherForecastsAreReturned(Table table)
        {
            table.CompareToSet(_actualWeatherForecasts);
        }

    }
}
