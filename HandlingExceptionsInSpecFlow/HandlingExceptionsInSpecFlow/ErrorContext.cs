using System;
using System.Linq;
using System.Collections.Generic;
using System.Diagnostics;
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

        public void AssertExceptionWasRaisedWithMessage(string expectedErrorMessage)
        {
            var actualException = _exceptions.Dequeue();
            Assert.IsNotNull(actualException, "No exception was raised");
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
