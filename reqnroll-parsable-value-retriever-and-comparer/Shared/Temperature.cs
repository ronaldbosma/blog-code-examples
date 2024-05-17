using System.Diagnostics.CodeAnalysis;
using System.Text.RegularExpressions;

namespace ReqnrollParsableValueRetrieverAndComparer.Shared
{
    public record Temperature : IParsable<Temperature>
    {
        private readonly static Regex TemperatureRegex = new(@"^(-?\d+) (°C|°F)$");

        public int Degrees { get; init; }

        public TemperatureUnit Unit { get; init; }

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
                    var degrees = int.Parse(regexMatches[0].Groups[1].Value);
                    var unit = regexMatches[0].Groups[2].Value;

                    result = new Temperature
                    {
                        Degrees = degrees,
                        Unit = unit == "°C" ? TemperatureUnit.Celsius : TemperatureUnit.Fahrenheit
                    };
                    return true;
                }
            }

            result = null;
            return false;
        }
    }
}
