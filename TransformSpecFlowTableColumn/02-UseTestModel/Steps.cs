﻿using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using TransformSpecFlowTableColumn.Shared;

namespace TransformSpecFlowTableColumn.UseTestModel
{
    [Binding]
    internal class Steps
    {
        private readonly WeatherForecastRepository _repository = new ();
        private IEnumerable<IWeatherForecast>? _actualWeatherForecasts;

        /// <summary>
        /// This method transform the Table into IEnumerable<WeatherForecast>,
        /// which then can be used as a parameter type in our steps.
        /// </summary>
        /// <seealso cref="https://docs.specflow.org/projects/specflow/en/latest/Bindings/Step-Argument-Conversions.html"/>
        [StepArgumentTransformation]
        public IEnumerable<WeatherForecast> TransformTableToWeatherForecast(Table table)
        {
            return table.CreateSet<WeatherForecastTestModel>()
                        .Select(t => new WeatherForecast
                        {
                            Date = t.Date,
                            LocationId = t.Location.LocationToId(),
                            Temperature = t.Temperature
                        });
        }

        [Given(@"the weather forecasts")]
        public void GivenTheWeatherForecasts(IEnumerable<WeatherForecast> weatherForecasts)
        {
            _repository.Register(weatherForecasts);
        }

        [When(@"the weather forecasts for '([^']*)' are retrieved")]
        public void WhenTheWeatherForecastsForAreRetrieved(string location)
        {
            int locationId = location.LocationToId();
            _actualWeatherForecasts = _repository.GetByLocation(locationId);
        }

        [Then(@"the following weather forecasts are returned")]
        public void ThenTheFollowingWeatherForecastsAreReturned(IEnumerable<WeatherForecast> expectedWeatherForecasts)
        {
            _actualWeatherForecasts.Should().BeEquivalentTo(expectedWeatherForecasts);
        }
    }
}