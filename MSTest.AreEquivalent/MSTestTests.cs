using MSTest.AreEquivalent.Models;

namespace MSTest.AreEquivalent
{
    [TestClass]
    public sealed class MSTestTests
    {
        [TestMethod]
        public void AreEquivalent_ExpectedAndActualAreTheSameObject_Success()
        {
            // Arrange
            var expectedAndActual = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            // Act & Assert
            Assert.AreEqual(expectedAndActual, expectedAndActual);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualAreDifferentObjectsOfSameTypeWithSameValues_Success()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = expected.CreateCopy();

            // Act & Assert
            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualHaveDifferentValues_AssertionFails()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.CreateCopy();
            actual.Street = "456 Elm St";

            // Act
            var act = () => Assert.AreEqual(expected, actual);

            // Assert
            Assert.ThrowsExactly<AssertFailedException>(act);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualAreDifferentObjectsOfDifferentTypeButWithSameValues_Success()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = expected.MapToExternal();

            // Act & Assert
            Assert.AreEqual<object>(expected, actual);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfDifferentTypeWithDifferentValues_AssertionFails()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.MapToExternal();
            actual.Street = "456 Elm St";

            // Act
            var act = () => Assert.AreEqual<object>(expected, actual);

            // Assert
            Assert.ThrowsExactly<AssertFailedException>(act);
        }

        [TestMethod]
        public void AreEquivalent_EquivalentComplexObjects_Success()
        {
            // Arrange
            var expected = new PersonInternal("John", "Doe", 30,
                new AddressInternal("123 Main St", "Anytown", "CA", "12345"));
            var actual = expected.MapToExternal();

            // Act & Assert
            Assert.AreEqual<object>(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualHaveDifferentValueButPropertyIsIgnored_FailsBecauseIgnoringPropertiesIsNotSupported()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.CreateCopy();
            actual.Street = "456 Elm St";

            // Act & Assert

            // MSTEST DOESN'T SUPPORT IGNORING PROPERTIES, SO THIS TEST WILL FAIL
            Assert.AreEqual<object>(expected, actual);
        }
    }
}
