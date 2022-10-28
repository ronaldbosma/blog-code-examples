using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.UseCustomTypeWithValueRetrieverAndComparer
{
    [Binding]
    internal class Steps
    {
        private readonly WeatherForecastWithCustomLocationIdTypeRepository _repository = new();
        private IEnumerable<WeatherForecastWithCustomLocationIdType>? _actualWeatherForecasts;

        [BeforeTestRun]
        public static void RegisterValueRetrieverAndComparer()
        {
            Service.Instance.ValueRetrievers.Register(new LocationIdValueRetriever());
            Service.Instance.ValueComparers.Register(new LocationIdValueComparer());
        }

        [Given(@"the weather forecasts")]
        public void GivenTheWeatherForecasts(Table table)
        {
            var weatherForecasts = table.CreateSet<WeatherForecastWithCustomLocationIdType>();
            _repository.Register(weatherForecasts);
        }

        [When(@"the weather forecasts for '([^']*)' are retrieved")]
        public void WhenTheWeatherForecastsForAreRetrieved(string location)
        {
            var locationId = new LocationId(location.LocationToId());
            _actualWeatherForecasts = _repository.GetByLocation(locationId);
        }

        [Then(@"the following weather forecasts are returned")]
        public void ThenTheFollowingWeatherForecastsAreReturned(Table table)
        {
            table.CompareToSet(_actualWeatherForecasts);
        }
    }
}
