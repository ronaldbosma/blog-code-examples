using MSTest.AreEquivalent.Models;
using AwesomeAssertions;

namespace MSTest.AreEquivalent
{
    [TestClass]
    public sealed class AwesomeAssertionsTests
    {
        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreTheSameObject_Success()
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
            expectedAndActual.Should().BeEquivalentTo(expectedAndActual);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfSameTypeWithSameValues_Success()
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
            actual.Should().BeEquivalentTo(expected);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualHaveDifferentValues_AssertionFails()
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
            var act = () => actual.Should().BeEquivalentTo(expected);

            // Assert
            act.Should().Throw<AssertFailedException>();
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfDifferentTypeButWithSameValues_Success()
        {
            // Arrange
            var expected = new AddressInternal
            {
                Street = "123 Main St",
                City = "Anytown",
                State = "CA",
                ZipCode = "12345"
            };
            var actual = new AddressExternal
            {
                Street = "123 Main St",
                City = "Anytown",
                State = "CA",
                ZipCode = "12345"
            };

            // Act & Assert
            actual.Should().BeEquivalentTo(expected);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_EquivalentComplexObjects_Success()
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
            actual.Should().BeEquivalentTo(expected);
        }
    }
}
