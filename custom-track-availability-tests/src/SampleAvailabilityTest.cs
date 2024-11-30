using Microsoft.ApplicationInsights;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace Sample.AvailabilityTests
{
    public class SampleAvailabilityTest
    {
        private readonly ILogger _logger;
        private readonly TelemetryClient _telemetryClient;
        private readonly IHttpClientFactory _httpClientFactory;

        public SampleAvailabilityTest(ILoggerFactory loggerFactory, TelemetryClient telemetryClient, IHttpClientFactory httpClientFactory)
        {
            _logger = loggerFactory.CreateLogger<SampleAvailabilityTest>();
            _telemetryClient = telemetryClient;
            _httpClientFactory = httpClientFactory;
        }

        [Function("SampleAvailabilityTest")]
        public void Run([TimerTrigger("0 * * * * *")] TimerInfo timerInfo)
        {
            var availabilityTest = new AvailabilityTest("API Management Status", CheckApiManagementAvailabilityAsync, _telemetryClient);
        }

        private async Task CheckApiManagementAvailabilityAsync()
        {
            _logger.LogInformation("Check availability of API Management");
            
            var httpClient = _httpClientFactory.CreateClient("ApimClient");
            var response = await httpClient.GetAsync("/internal-status-0123456789abcdef");
            response.EnsureSuccessStatusCode();
        }
    }
}
