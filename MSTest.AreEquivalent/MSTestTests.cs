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
            var expectedAndActual = new AddressInternal
            {
                Street = "123 Main St",
                City = "Anytown",
                State = "CA",
                ZipCode = "12345"
            };

            // Act & Assert
            Assert.AreEqual(expectedAndActual, expectedAndActual);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualAreDifferentObjectsOfSameTypeWithSameValues_Success()
        {
            // Arrange
            var expected = new AddressInternal
            {
                Street = "123 Main St",
                City = "Anytown",
                State = "CA",
                ZipCode = "12345"
            };
            var actual = expected.CreateCopy();

            // Act & Assert
            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualHaveDifferentValues_AssertionFails()
        {
            // Arrange
            var expected = new AddressInternal
            {
                Street = "123 Main St",
                City = "Anytown",
                State = "CA",
                ZipCode = "12345"
            };

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
            var expected = new AddressInternal
            {
                Street = "123 Main St",
                City = "Anytown",
                State = "CA",
                ZipCode = "12345"
            };
            var actual = expected.MapToExternal();

            // Act & Assert
            Assert.AreEqual<object>(expected, actual);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfDifferentTypeWithDifferentValues_AssertionFails()
        {
            // Arrange
            var expected = new AddressInternal
            {
                Street = "123 Main St",
                City = "Anytown",
                State = "CA",
                ZipCode = "12345"
            };

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
            var expected = new PersonInternal
            {
                FirstName = "John",
                LastName = "Doe",
                Age = 30,
                Address = new AddressInternal
                {
                    Street = "123 Main St",
                    City = "Anytown",
                    State = "CA",
                    ZipCode = "12345"
                }
            };
            var actual = expected.MapToExternal();

            // Act & Assert
            Assert.AreEqual<object>(expected, actual);
        }
    }
}
