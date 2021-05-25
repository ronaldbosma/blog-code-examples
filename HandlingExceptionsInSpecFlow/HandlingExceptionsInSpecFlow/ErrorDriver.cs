using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace HandlingExceptionsInSpecFlow
{
    /// <summary>
    /// Context class that can be used to track exceptions.
    /// </summary>
    internal class ErrorDriver
    {
        private readonly Queue<Exception> _exceptions = new Queue<Exception>();

        /// <summary>
        /// Executes <paramref name="act"/>. Any exception raised will be caught and registered in this instance of <see cref="ErrorDriver" />.
        /// </summary>
        /// <param name="act">The action to execute.</param>
        [SuppressMessage("Design", "CA1031:Do not catch general exception types", Justification = "Intentionally catches all exceptions to be handled later")]
        public void TryExecute(Action act)
        {
            if (act is null)
            {
                throw new ArgumentNullException(nameof(act));
            }

            try
            {
                act();
            }
            catch (Exception ex)
            {
                Trace.WriteLine($"The following exception was caught while executing {act.Method.Name}: {ex}");
                _exceptions.Enqueue(ex);
            }
        }

        /// <summary>
        /// Executes <paramref name="act"/>. Any exception raised will be caught and registered in this instance of <see cref="ErrorDriver" />.
        /// </summary>
        /// <param name="act">The action to execute.</param>
        [SuppressMessage("Design", "CA1031:Do not catch general exception types", Justification = "Intentionally catches all exceptions to be handled later")]
        public async Task TryExecuteAsync(Func<Task> act)
        {
            if (act is null)
            {
                throw new ArgumentNullException(nameof(act));
            }

            try
            {
                await act();
            }
            catch (Exception ex)
            {
                Trace.WriteLine($"The following exception was caught while executing {act.Method.Name}: {ex}");
                _exceptions.Enqueue(ex);
            }
        }

        /// <summary>
        /// Asserts that an exception was raised with <paramref name="expectedErrorMessage"/> as the message.
        /// </summary>
        /// <param name="expectedErrorMessage">The expected error message.</param>
        public void AssertExceptionWasRaisedWithMessage(string expectedErrorMessage)
        {
            if (expectedErrorMessage is null)
            {
                throw new ArgumentNullException(nameof(expectedErrorMessage));
            }

            Assert.IsTrue(_exceptions.Any(), $"No exception was raised but expected exception with message: {expectedErrorMessage}");

            var actualException = _exceptions.Dequeue();
            Assert.AreEqual(expectedErrorMessage, actualException.Message);
        }

        /// <summary>
        /// Asserts that no unexpected exception was raised.
        /// </summary>
        public void AssertNoUnexpectedExceptionsRaised()
        {
            if (_exceptions.Any())
            {
                var unexpectedException = _exceptions.Dequeue();
                Assert.Fail($"No exception was expected to be raised but found exception: {unexpectedException}"); 
            }
        }
    }
}
