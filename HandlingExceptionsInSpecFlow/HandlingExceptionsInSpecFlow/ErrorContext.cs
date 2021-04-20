using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace HandlingExceptionsInSpecFlow
{
    public class ErrorContext
    {
        private readonly Queue<Exception> _exceptions = new Queue<Exception>();

        public void TryExecute(Action act)
        {
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

        public async Task TryExecuteAsync(Func<Task> act)
        {
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

        public void AssertExceptionWasRaisedWithMessage(string expectedErrorMessage)
        {
            Assert.IsTrue(_exceptions.Any(), $"No exception was raised but expected exception with message: {expectedErrorMessage}");

            var actualException = _exceptions.Dequeue();
            Assert.AreEqual(expectedErrorMessage, actualException.Message, 
                $"Exception with message '{expectedErrorMessage}' expected but found exception with message '{actualException.Message}'");
        }

        public void AssertNoUnexpectedExceptionsRaised()
        {
            if (_exceptions.Any())
            {
                var unexpectedException = _exceptions.Dequeue();
                Assert.IsNull(unexpectedException, $"No exception was expected to be raised but found exception: {unexpectedException}"); 
            }
        }
    }
}
