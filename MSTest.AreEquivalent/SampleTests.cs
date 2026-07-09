using MSTest.AreEquivalent.Models;

namespace MSTest.AreEquivalent
{
    [TestClass]
    public sealed class SampleTests
    {
        [TestMethod]
        public void AreEqual_ExpectedAndActualAreSameObject_Success()
        {
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = expected;

            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void AreEqual_ExpectedAndActualAreDifferentTypesWithDifferentValues_AssertionFails()
        {
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = new AddressInternal("456 Elm St", "Othertown", "NY", "67890");

            var act = () => Assert.AreEqual(expected, actual);

            Assert.ThrowsExactly<AssertFailedException>(act);
        }

        [TestMethod]
        public void AreEqual_ExpectedAndActualAreDifferentTypesWithSameValues_AlthoughObjectsAreEquivalent()
        {
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = new AddressExternal("123 Main St", "Anytown", "CA", "12345");

            Assert.AreEqual<object>(expected, actual);
        }

        //[TestMethod]
        //public void AreEquivalent_ExpectedAndActualAreSameObject_Success()
        //{
        //    var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
        //    var actual = expected;

        //    Assert.AreEquivalent(expected, actual);
        //}

        //[TestMethod]
        //public void AreEquivalent_ExpectedAndActualAreDifferentTypesWithDifferentValues_AssertionFails()
        //{
        //    var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
        //    var actual = new AddressInternal("456 Elm St", "Othertown", "NY", "67890");

        //    var act = () => Assert.AreEquivalent(expected, actual);

        //    Assert.ThrowsExactly<AssertFailedException>(act);
        //}

        //[TestMethod]
        //public void AreEquivalent_ExpectedAndActualAreDifferentTypesWithSameValues_Success()
        //{
        //    var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
        //    var actual = new AddressExternal("123 Main St", "Anytown", "CA", "12345");

        //    Assert.AreEquivalent(expected, actual);
        //}

        //[TestMethod]
        //public void AreEquivalent_EquivalentNestedObjectsOfDifferentTypes_Success()
        //{
        //    var expected = new PersonInternal("John", "Doe", 30,
        //        new AddressInternal("123 Main St", "Anytown", "CA", "12345"));
        //    var actual = new PersonExternal("John", "Doe", 30,
        //        new AddressExternal("123 Main St", "Anytown", "CA", "12345"));

        //    Assert.AreEquivalent(expected, actual);
        //}

        //[TestMethod]
        //public void AreEquivalent_CollectionsWithSameObjects_Success()
        //{
        //    var expected = new List<AddressInternal>
        //    {
        //        new AddressInternal("123 Main St", "Anytown", "CA", "12345"),
        //        new AddressInternal("456 Elm St", "Othertown", "NY", "67890")
        //    };
        //            var actual = new List<AddressInternal>
        //    {
        //        new AddressInternal("123 Main St", "Anytown", "CA", "12345"),
        //        new AddressInternal("456 Elm St", "Othertown", "NY", "67890")
        //    };

        //    Assert.AreEquivalent(expected, actual);
        //}
    }
}
