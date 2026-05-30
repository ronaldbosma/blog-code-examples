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
            var expectedAndActual = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            // Act & Assert
            expectedAndActual.ShouldBeEquivalentTo(expectedAndActual);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfSameTypeWithSameValues_Success()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = expected.CreateCopy();

            // Act & Assert
            actual.ShouldBeEquivalentTo(expected);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualHaveDifferentValues_AssertionFails()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.CreateCopy();
            actual.Street = "456 Elm St";

            // Act
            var act = () => actual.ShouldBeEquivalentTo(expected);

            // Assert
            act.ShouldThrow<ShouldAssertException>();
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfDifferentTypeButWithSameValues_FailsAlthoughObjectsAreEquivalent()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = expected.MapToExternal();

            // Act & Assert
            actual.ShouldBeEquivalentTo(expected);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfDifferentTypeWithDifferentValues_AssertionFails()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.MapToExternal();
            actual.Street = "456 Elm St";

            // Act
            var act = () => actual.ShouldBeEquivalentTo(expected);

            // Assert
            act.ShouldThrow<ShouldAssertException>();
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_EquivalentComplexObjects_FailsAlthoughObjectsAreEquivalent()
        {
            // Arrange
            var expected = new PersonInternal("John", "Doe", 30,
                new AddressInternal("123 Main St", "Anytown", "CA", "12345"));
            var actual = expected.MapToExternal();

            // Act & Assert
            actual.ShouldBeEquivalentTo(expected);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_EquivalentListOfAddresses_Success()
        {
            // Arrange
            var expected = new List<AddressInternal>
            {
                new AddressInternal("123 Main St", "Anytown", "CA", "12345"),
                new AddressInternal("456 Elm St", "Othertown", "NY", "67890"),
                new AddressInternal("789 Oak St", "Sometown", "TX", "54321")
            };
            var actual = expected.Select(a => a.CreateCopy()).ToList();

            // Act & Assert
            actual.ShouldBeEquivalentTo(expected);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_DifferentListOfAddresses_AssertionFails()
        {
            // Arrange
            var expected = new List<AddressInternal>
            {
                new AddressInternal("123 Main St", "Anytown", "CA", "12345"),
                new AddressInternal("456 Elm St", "Othertown", "NY", "67890"),
                new AddressInternal("789 Oak St", "Sometown", "TX", "54321")
            };

            var actual = expected.Select(a => a.CreateCopy()).ToList();
            actual[1].Street = "999 Pine St";

            // Act
            var act = () => actual.ShouldBeEquivalentTo(expected);

            // Assert
            act.ShouldThrow<ShouldAssertException>();
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualHaveDifferentValueButPropertyIsIgnored_FailsBecauseIgnoringPropertiesIsNotSupported()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.CreateCopy();
            actual.Street = "456 Elm St";

            // Act & Assert

            // MSTEST DOESN'T SUPPORT IGNORING PROPERTIES, SO THIS TEST WILL FAIL
            actual.ShouldBeEquivalentTo(expected);
        }
    }
}
