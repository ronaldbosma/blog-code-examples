using System.Diagnostics.CodeAnalysis;
using System.Globalization;

namespace ReqnrollParsableValueRetrieverAndComparer.Reflection
{
    /// <summary>
    /// Helper class to work with the <see cref="IParsable{TSelf}"/> interface when you don't now TSelf at compile time.
    /// </summary>
    internal static class GenericParsableParser
    {
        /// <summary>
        /// Checks if the type implements IParsable<TSelf> where TSelf is a supported type.
        /// </summary>
        public static bool ImplementsSupportedIParsable(Type type)
        {
            return type.GetInterfaces().Any(i =>
                i.IsGenericType &&
                i.GetGenericTypeDefinition() == typeof(IParsable<>) &&
                // IParsable<string> is exluded because we can't dynamically create an instance of string
                i.GetGenericArguments()[0] != typeof(string)
            );
        }

        /// <summary>
        /// Parses <paramref name="s"/> to <paramref name="targetType"/>.
        /// </summary>
        public static object Parse(Type targetType, string s, IFormatProvider? formatProvider)
        {
            if (TryParse(targetType, s, formatProvider, out object? result))
            {
                return result;
            }
            else
            {
                throw new ArgumentException($"Unable to parse '{s}' to type {targetType}");
            }
        }

        /// <summary>
        /// Tries to parse <paramref name="s"/> to <paramref name="targetType"/>.
        /// </summary>
        public static bool TryParse(Type targetType, [NotNullWhen(true)] string? s, IFormatProvider? formatProvider, [MaybeNullWhen(false)] out object result)
        {
            // Check if the target type implements IParsable<TSelf>
            if (!ImplementsSupportedIParsable(targetType))
            {
                result = null;
                return false;
            }

            // Get the IParsable<TSelf> interface implemented by the target type
            var parsableInterface = targetType
                .GetInterfaces()
                .FirstOrDefault(i => i.IsGenericType && i.GetGenericTypeDefinition() == typeof(IParsable<>));

            if (parsableInterface == null)
            {
                throw new ArgumentException($"Type {targetType} does not implement IParsable<TSelf>");
            }

            // Get the type parameter TSelf of IParsable<TSelf>
            var parsableType = parsableInterface.GetGenericArguments().Single();

            // Create an instance of TSelf
            var parsableInstance = Activator.CreateInstance(parsableType);
            if (parsableInstance == null)
            {
                throw new Exception($"Unable to create instance of type {parsableType}");
            }

            // Get the TryParse method of TSelf with signature: TryParse(String, IFormatProvider, out TSelf)
            var parseMethod = parsableType.GetMethod("TryParse", [typeof(string), typeof(CultureInfo), parsableType.MakeByRefType()]);
            if (parseMethod == null)
            {
                throw new Exception($"Unable to get method with signature TryParse(String, IFormatProvider, out TSelf) from type {parsableType}");
            }

            // Invoke the TryParse method
            object?[] parameters = [s, formatProvider, null];
            var tryParseResult = (bool?)parseMethod.Invoke(parsableInstance, parameters);
            if (tryParseResult == null)
            {
                throw new Exception($"TryParse method on type {parsableType} unexpectedly returned null for value: {s}");
            }

            // Set result to the parsed result if TryParse was successful
            result = (bool)tryParseResult ? parameters[2] : null;

            return (bool)tryParseResult;
        }
    }
}
