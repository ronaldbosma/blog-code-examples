using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace TransformSpecFlowTableColumn.UseValueRetriever
{
    [Binding]
    internal class Steps
    {
        private readonly WeatherForecastRepository _repository = new();
        private WeatherForecast? _actualWeatherForecast;

        [BeforeTestRun]
        public static void RegisterValueRetriever()
        {
            Service.Instance.ValueRetrievers.Register(new LocationIdValueRetriever());
        }

        [Given(@"the weather forecasts")]
        public void GivenTheWeatherForecasts(Table table)
        {
            var weatherForecasts = table.CreateSet<WeatherForecast>();
            _repository.Register(weatherForecasts);
        }

        [When(@"the weather forecast for '([^']*)' on '([^']*)' is retrieved")]
        public void WhenTheWeatherForecastForLocationOnDateIsRetrieved(string location, DateTime date)
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
