using Reqnroll;
using Reqnroll.Assist;
using ReqnrollParsableValueRetrieverAndComparer.Shared;

namespace ReqnrollParsableValueRetrieverAndComparer.Init
{
    [Binding]
    internal class GenericTypesSteps
    {
        private IEnumerable<WeatherForecast>? _actualWeatherForecasts;

        [BeforeTestRun]
        public static void BeforeTestRun()
        {
            Service.Instance.ValueRetrievers.Register(new ParsableValueRetriever<DateOnly>());
            Service.Instance.ValueRetrievers.Register(new ParsableValueRetriever<Temperature>());

            Service.Instance.ValueComparers.Register(new ParsableValueComparer<DateOnly>());
            Service.Instance.ValueComparers.Register(new ParsableValueComparer<Temperature>());
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
