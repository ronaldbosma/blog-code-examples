using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = FunctionsApplication.CreateBuilder(args);

builder.ConfigureFunctionsWebApplication();

// Enable Application Insights
builder.Services
    .AddApplicationInsightsTelemetryWorkerService()
    .ConfigureFunctionsApplicationInsights();

// Add the telemetry client that is used to publish availability test results
var telemetryConfiguration = new TelemetryConfiguration()
{
    ConnectionString = Environment.GetEnvironmentVariable("APPLICATIONINSIGHTS_CONNECTION_STRING"),
    TelemetryChannel = new InMemoryChannel()
};
builder.Services.AddSingleton(new TelemetryClient(telemetryConfiguration));


// Add HTTP client for API Management
builder.Services.AddHttpClient("ApimClient", httpClient =>
{
    httpClient.BaseAddress = new Uri("https://apim-aisquick-demo-nwe-01.azure-api.net");
});

builder.Build().Run();
