using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.UseValueRetriever
{
    [Binding]
    internal class Steps
    {
        private readonly WeatherForecastRepository _repository = new();
        private IEnumerable<IWeatherForecast>? _actualWeatherForecasts;

        [BeforeTestRun]
        public static void RegisterValueRetriever()
        {
            Service.Instance.ValueRetrievers.Register(new LocationIdValueRetriever());
        }

        [Given(@"the weather forecasts")]
        public void GivenTheWeatherForecasts(Table table)
        {
            // Mapping to WeatherForecast doesn't work because the column is named 'Location' while the property is named 'LocationId'
            // var weatherForecasts = table.CreateSet<WeatherForecast>();

            var weatherForecasts = table.CreateSet<WeatherForecastWithTableAlias>();
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
            IEnumerable<WeatherForecastWithTableAlias>? actual = _actualWeatherForecasts?.Cast<WeatherForecastWithTableAlias>();
            table.CompareToSet(actual);
        }
    }
}
