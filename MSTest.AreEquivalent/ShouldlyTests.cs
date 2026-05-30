using MSTest.AreEquivalent.Models;
using Shouldly;

namespace MSTest.AreEquivalent
{
    [TestClass]
    public sealed class ShouldlyTests
    {
        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreTheSameObject_Success()
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
            expectedAndActualPerson.ShouldBeEquivalentTo(expectedAndActualPerson);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfSameTypeWithSameValues_Success()
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
            actual.ShouldBeEquivalentTo(expected);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualHaveDifferentValues_AssertionFails()
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
            var act = () => actual.ShouldBeEquivalentTo(expected);

            // Assert
            act.ShouldThrow<ShouldAssertException>();
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfDifferentTypeButWithSameValues_Success()
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
            actual.ShouldBeEquivalentTo(expected);
        }
    }
}
