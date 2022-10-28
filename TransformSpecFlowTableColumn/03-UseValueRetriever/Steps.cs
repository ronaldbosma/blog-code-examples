using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.UseValueRetriever
{
    [Binding]
    internal class Steps
    {
        private readonly WeatherForecastRepository _repository = new();
        private IWeatherForecast? _actualWeatherForecast;

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

        [When(@"the weather forecast for '([^']*)' on '([^']*)' is retrieved")]
        public void WhenTheWeatherForecastForOnIsRetrieved(string location, DateTime date)
        {
            int locationId = location.LocationToId();
            _actualWeatherForecast = _repository.GetByDateAndLocation(date, locationId);
        }

        [Then(@"the following weather forecast is returned")]
        public void ThenTheFollowingWeatherForecastIsReturned(Table table)
        {
            table.CompareToInstance(_actualWeatherForecast);
        }
    }
}
