using System.Diagnostics.CodeAnalysis;
using System.Text.RegularExpressions;

namespace ReqnrollParsableValueRetrieverAndComparer.Shared
{
    public record Temperature : IParsable<Temperature>
    {
        private readonly static Regex TemperatureRegex = new(@"^(-?\d+) (°C|°F)$");

        public int DegreesCelsius { get; init; }

        public int DegreesFahrenheit { get; init; }

        /// <summary>
        /// Creates a <see cref="Temperature"/> object from the specified <paramref name="degreesCelsius"/>.
        /// </summary>
        public static Temperature FromDegreesCelsius(int degreesCelsius)
        {
            decimal degreesFahrenheit = (decimal)degreesCelsius * 9 / 5 + 32;

            return new Temperature
            {
                DegreesCelsius = degreesCelsius,
                DegreesFahrenheit = (int)Math.Round(degreesFahrenheit, 0, MidpointRounding.AwayFromZero)
            };
        }

        /// <summary>
        /// Creates a <see cref="Temperature"/> object from the specified <paramref name="degreesFahrenheit"/>.
        /// </summary>
        public static Temperature FromDegreesFahrenheit(int degreesFahrenheit)
        {
            decimal degreesCelsius = ((decimal)degreesFahrenheit - 32) * 5 / 9;

            return new Temperature
            {
                DegreesCelsius = (int)Math.Round(degreesCelsius, 0, MidpointRounding.AwayFromZero),
                DegreesFahrenheit = degreesFahrenheit
            };
        }

        /// <summary>
        /// Parse <paramref name="temperature"/> into a <see cref="Temperature"/> object.
        /// </summary>
        /// <param name="s">The value to parse. This should be a number followed by either °C or °F. Example: 21 °C</param>
        /// <param name="provider">This parameter is not used</param>
        /// <returns>The parsed temperature.</returns>
        /// <exception cref="FormatException">Thrown when the value can not be parsed.</exception>
        public static Temperature Parse(string s, IFormatProvider? provider)
        {
            var isValidTemperature = TryParse(s, provider, out var result);

            if (isValidTemperature && result is not null)
            {
                return result;
            }
            else
            {
                throw new FormatException($"The value '{s}' is not in the correct format.");
            }
        }

        /// <summary>
        /// Tries to parse <paramref name="temperature"/> into a <see cref="Temperature"/> object.
        /// </summary>
        /// <param name="temperature">The value to parse. This should be a number followed by either °C or °F. Example: 21 °C</param>
        /// <param name="provider">This parameter is not used</param>
        /// <param name="result">The parsed <see cref="Temperature"/> object if valid, else null.</param>
        /// <returns>True if <paramref name="temperature"/> could be parsed, else false.</returns>
        public static bool TryParse([NotNullWhen(true)] string? s, IFormatProvider? provider, [MaybeNullWhen(false)] out Temperature result)
        {
            if (s != null)
            {
                var regexMatches = TemperatureRegex.Matches(s);

                if (regexMatches.Count == 1)
                {
                    var temperatureValue = int.Parse(regexMatches[0].Groups[1].Value);
                    var temperatureUnit = regexMatches[0].Groups[2].Value;

                    result = temperatureUnit == "°C" ? FromDegreesCelsius(temperatureValue) : FromDegreesFahrenheit(temperatureValue);
                    return true;
                }
            }

            result = null;
            return false;
        }
    }
}
