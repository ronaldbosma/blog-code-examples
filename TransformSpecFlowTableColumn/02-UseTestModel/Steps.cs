using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.UseTestModel
{
    [Binding]
    internal class Steps
    {
        private readonly WeatherForecastRepository _repository = new ();
        private IWeatherForecast? _actualWeatherForecast;

        /// <summary>
        /// This method transform the Table into IEnumerable<WeatherForecast>,
        /// which then can be used as a parameter type in our steps.
        /// </summary>
        /// <seealso cref="https://docs.specflow.org/projects/specflow/en/latest/Bindings/Step-Argument-Conversions.html"/>
        [StepArgumentTransformation]
        public IEnumerable<WeatherForecast> TransformTableToWeatherForecasts(Table table)
        {
            return table.CreateSet<WeatherForecastTestModel>()
                        .Select(t => new WeatherForecast
                        {
                            Date = t.Date,
                            LocationId = t.Location.LocationToId(),
                            Temperature = t.Temperature
                        });
        }

        [StepArgumentTransformation]
        public WeatherForecast TransformTableToWeatherForecast(Table table)
        {
            return TransformTableToWeatherForecasts(table).Single();
        }


        [Given(@"the weather forecasts")]
        public void GivenTheWeatherForecasts(IEnumerable<WeatherForecast> weatherForecasts)
        {
            _repository.Register(weatherForecasts);
        }

        [When(@"the weather forecast for '([^']*)' on '([^']*)' is retrieved")]
        public void WhenTheWeatherForecastForOnIsRetrieved(string location, DateTime date)
        {
            int locationId = location.LocationToId();
            _actualWeatherForecast = _repository.GetByDateAndLocation(date, locationId);
        }

        [Then(@"the following weather forecast is returned")]
        public void ThenTheFollowingWeatherForecastIsReturned(WeatherForecast expectedWeatherForecasts)
        {
            _actualWeatherForecast.Should().BeEquivalentTo(expectedWeatherForecasts);
        }
    }
}
