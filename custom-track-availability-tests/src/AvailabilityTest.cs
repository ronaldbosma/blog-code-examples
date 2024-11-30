using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.DataContracts;
using System.Diagnostics;

namespace Sample.AvailabilityTests;

/// <summary>
/// Generic class for availability tests.
/// </summary>
internal class AvailabilityTest
{
    private readonly string _name;
    private readonly Func<Task> _checkAvailabilityAsync;
    private readonly TelemetryClient _telemetryClient;

    /// <summary>
    /// Creates instance of <see cref="AvailabilityTest"/>.
    /// </summary>
    /// <param name="name">The name of the availability test.</param>
    /// <param name="checkAvailability">The function that checks the availability.</param>
    /// <param name="telemetryClient">The telemetry client to publish the result to.</param>
    public AvailabilityTest(string name, Func<Task> checkAvailabilityAsync, TelemetryClient telemetryClient)
    {
        _name = name;
        _checkAvailabilityAsync = checkAvailabilityAsync;
        _telemetryClient = telemetryClient;
    }

    /// <inheritdoc/>
    public async Task ExecuteAsync()
    {
        var availability = new AvailabilityTelemetry
        {
            Name = _name,
            RunLocation = Environment.GetEnvironmentVariable("REGION_NAME") ?? "Unknown",
            Success = false
        };

        var stopwatch = new Stopwatch();
        stopwatch.Start();

        try
        {
            using (var activity = new Activity("AvailabilityContext"))
            {
                activity.Start();
                
                // Connect the availability telemetry to the logging activity
                availability.Id = activity.SpanId.ToString();
                availability.Context.Operation.ParentId = activity.ParentSpanId.ToString();
                availability.Context.Operation.Id = activity.RootId;

                await _checkAvailabilityAsync();
            }

            availability.Success = true;
        }
        catch (Exception ex)
        {
            availability.Message = ex.Message;
            availability.Properties.Add("Exception", ex.ToString());
            throw;
        }
        finally
        {
            stopwatch.Stop();
            availability.Duration = stopwatch.Elapsed;
            availability.Timestamp = DateTimeOffset.UtcNow;

            _telemetryClient.TrackAvailability(availability);
            _telemetryClient.Flush();
        }
    }
}
