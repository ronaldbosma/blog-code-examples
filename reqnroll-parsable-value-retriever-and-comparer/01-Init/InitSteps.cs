using Reqnroll;
using Reqnroll.Assist;
using ReqnrollParsableValueRetrieverAndComparer.Shared;

namespace ReqnrollParsableValueRetrieverAndComparer.Init
{
    [Binding]
    internal class InitSteps
    {
        private IEnumerable<WeatherForecast>? _actualWeatherForecasts;

        [BeforeTestRun]
        public static void BeforeTestRun()
        {
            Service.Instance.ValueRetrievers.Register(new DateOnlyValueRetriever());
            Service.Instance.ValueRetrievers.Register(new TemperatureValueRetriever());

            Service.Instance.ValueComparers.Register(new DateOnlyValueComparer());
            Service.Instance.ValueComparers.Register(new TemperatureValueComparer());
        }

        [When("the following table is converted into weather forecasts")]
        public void WhenTheFollowingTableIsConvertedIntoWeatherForecasts(DataTable dataTable)
        {
            _actualWeatherForecasts = dataTable.CreateSet<WeatherForecast>();
        }

        [Then("the following weather forecasts are created")]
        public void ThenTheFollowingWeatherForecastsAreCreated(DataTable dataTable)
        {
            dataTable.CompareToSet(_actualWeatherForecasts);
        }
    }
}
