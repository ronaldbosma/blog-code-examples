using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.UseTestModel
{
    [Binding]
    internal class Steps
    {
        private readonly WeatherForecastRepository _repository = new WeatherForecastRepository();
        private IEnumerable<WeatherForecast>? _actualWeatherForecasts;

        [Given(@"the weather forecasts")]
        public void GivenTheWeatherForecasts(Table table)
        {
            var weatherForecasts = table.CreateSet<WeatherForecast>();
            _repository.Register(weatherForecasts);
        }

        [When(@"the weather forecasts for '([^']*)' are retrieved")]
        public void WhenTheWeatherForecastsForAreRetrieved(string location)
        {
            var locationId = location.NameToId();
            _actualWeatherForecasts = _repository.GetByLocation(locationId);
        }

        [Then(@"the following weather forecasts are returned")]
        public void ThenTheFollowingWeatherForecastsAreReturned(Table table)
        {
            table.CompareToSet(_actualWeatherForecasts);
        }

    }
}
