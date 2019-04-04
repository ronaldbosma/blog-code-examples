using Examples.Models;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Examples._06_ImplicitConversionForBuild
{
    [TestClass]
    public class Tests
    {
        [TestMethod]
        public void TestRefactorAddressBuilding()
        {
            Person sherlock = A.Man.Called("Sherlock Holmes").LivingAt("221B Baker Street, London");

            Assert.AreEqual("Sherlock Holmes", sherlock.Name);
            Assert.AreEqual(Gender.Man, sherlock.Gender);
            Assert.AreEqual("Sherlock Holmes", sherlock.Name);
            Assert.AreEqual("221B Baker Street", sherlock.Address.AddressLine1);
            Assert.AreEqual("London", sherlock.Address.AddressLine2);
            Assert.AreEqual("GBR", sherlock.Address.CountryCode);
        }
    }
}
