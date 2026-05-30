using MSTest.AreEquivalent.Models;
using Shouldly;

namespace MSTest.AreEquivalent
{
    [TestClass]
    public sealed class MSTestTests
    {
        [TestMethod]
        public void AreEquivalent_ExpectedAndActualAreTheSameObject_Success()
        {
            // Arrange
            var expectedAndActualPerson = new PersonInternal
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

            // Act & Assert
            Assert.AreEqual(expectedAndActualPerson, expectedAndActualPerson);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualAreDifferentObjectsOfSameTypeWithSameValues_Success()
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
            var actual = expected;

            // Act & Assert
            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualHaveDifferentValues_AssertionFails()
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
            var actual = expected with { FirstName = "Jane" };

            // Act
            var act = () => Assert.AreEqual(expected, actual);

            // Assert
            act.ShouldThrow<AssertFailedException>();
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualAreDifferentObjectsOfDifferentTypeButWithSameValues_Success()
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
            var actual = new PersonExternal
            {
                FirstName = "John",
                LastName = "Doe",
                Age = 30,
                Address = new AddressExternal
                {
                    Street = "123 Main St",
                    City = "Anytown",
                    State = "CA",
                    ZipCode = "12345"
                }
            };

            // Act & Assert
            Assert.AreEqual<object>(expected, actual);
        }
    }
}
