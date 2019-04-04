using Examples.Models;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Examples._04_RenamingBuilderMethods
{
    [TestClass]
    public class Tests
    {
        [TestMethod]
        public void TestRenamingBuilderMethods()
        {
            Person sherlock = A.Man.Called("Sherlock Holmes")
              .LivingAt(
                new AddressBuilder()
                  .WithAddressLine1("221B Baker Street")
                  .WithAddressLine2("London")
                  .Build()
              )
              .Build();

            Assert.AreEqual("Sherlock Holmes", sherlock.Name);
            Assert.AreEqual(Gender.Man, sherlock.Gender);
            Assert.AreEqual("Sherlock Holmes", sherlock.Name);
            Assert.AreEqual("221B Baker Street", sherlock.Address.AddressLine1);
            Assert.AreEqual("London", sherlock.Address.AddressLine2);
            Assert.AreEqual("GBR", sherlock.Address.CountryCode);
        }
    }
}
