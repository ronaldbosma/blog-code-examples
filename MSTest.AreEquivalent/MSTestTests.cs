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
            Assert.AreEquivalent(expectedAndActual, expectedAndActual);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualAreDifferentObjectsOfSameTypeWithSameValues_Success()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = expected.CreateCopy();

            // Act & Assert
            Assert.AreEquivalent(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualHaveDifferentValues_AssertionFails()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.CreateCopy();
            actual.Street = "456 Elm St";

            // Act
            var act = () => Assert.AreEquivalent(expected, actual);

            // Assert
            var ex = Assert.ThrowsExactly<AssertFailedException>(act);
            StringAssert.Contains(ex.Message, "Street");
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualAreDifferentObjectsOfDifferentTypeButWithSameValues_Success()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = expected.MapToExternal();

            // Act & Assert
            Assert.AreEquivalent<object>(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedAndActualAreDifferentObjectsOfDifferentTypeWithDifferentValues_AssertionFails()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.MapToExternal();
            actual.Street = "456 Elm St";

            // Act
            var act = () => Assert.AreEquivalent<object>(expected, actual);

            // Assert
            var ex = Assert.ThrowsExactly<AssertFailedException>(act);
            StringAssert.Contains(ex.Message, "Street");
        }

        [TestMethod]
        public void AreEquivalent_EquivalentComplexObjectsOfDifferentTypes_Success()
        {
            // Arrange
            var expected = new PersonInternal("John", "Doe", 30,
                new AddressInternal("123 Main St", "Anytown", "CA", "12345"));
            var actual = expected.MapToExternal();

            // Act & Assert
            Assert.AreEquivalent<object>(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_EquivalentComplexObjectsOfDifferentTypesWithDifferentValueInChildObject_AssertionFails()
        {
            // Arrange
            var expected = new PersonInternal("John", "Doe", 30,
                new AddressInternal("123 Main St", "Anytown", "CA", "12345"));

            var actual = expected.MapToExternal();
            actual.Address.Street = "456 Elm St";

            // Act
            var act = () => Assert.AreEquivalent<object>(expected, actual);

            // Assert
            var ex = Assert.ThrowsExactly<AssertFailedException>(act);
            StringAssert.Contains(ex.Message, "Street");
        }

        /// <summary>
        /// This test will currently fail because MSTest does not support ignoring properties in the Assert.AreEquivalent assertion.
        /// This scenario is supported by AwesomeAssertions.
        /// </summary>
        [TestMethod]
        public void AreEquivalent_ExpectedAndActualHaveDifferentValueButPropertyIsIgnored_TestFailsBecauseIgnoringPropertiesIsNotSupported()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.CreateCopy();
            actual.Street = "456 Elm St";

            // Act & Assert
            Assert.AreEquivalent(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_EquivalentListOfObjects_Success()
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
            Assert.AreEquivalent(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_DifferentListOfObjects_AssertionFails()
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
            var act = () => Assert.AreEquivalent(expected, actual);

            // Assert
            var ex = Assert.ThrowsExactly<AssertFailedException>(act);
            StringAssert.Contains(ex.Message, "Street");
        }

        [TestMethod]
        public void AreEquivalent_EquivalentListOfObjectsWithComplexChildren_Success()
        {
            // Arrange
            var expected = new List<PersonInternal>
            {
                new PersonInternal("John", "Doe", 30, new AddressInternal("123 Main St", "Anytown", "CA", "12345")),
                new PersonInternal("Jane", "Smith", 25, new AddressInternal("456 Elm St", "Othertown", "NY", "67890")),
                new PersonInternal("Bob", "Johnson", 40, new AddressInternal("789 Oak St", "Sometown", "TX", "54321"))
            };
            var actual = expected.Select(a => a.CreateCopy()).ToList();

            // Act & Assert
            Assert.AreEquivalent(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_DifferentListOfObjectsWithComplexChildren_AssertionFails()
        {
            // Arrange
            var expected = new List<PersonInternal>
            {
                new PersonInternal("John", "Doe", 30, new AddressInternal("123 Main St", "Anytown", "CA", "12345")),
                new PersonInternal("Jane", "Smith", 25, new AddressInternal("456 Elm St", "Othertown", "NY", "67890")),
                new PersonInternal("Bob", "Johnson", 40, new AddressInternal("789 Oak St", "Sometown", "TX", "54321"))
            };

            var actual = expected.Select(a => a.CreateCopy()).ToList();
            actual[1].Address.Street = "999 Pine St";

            // Act
            var act = () => Assert.AreEquivalent(expected, actual);

            // Assert
            var ex = Assert.ThrowsExactly<AssertFailedException>(act);
            StringAssert.Contains(ex.Message, "Street");
        }

        /// <summary>
        /// This test will currently fail because MSTest does not support ignoring properties in the Assert.AreEquivalent assertion.
        /// This scenario is supported by AwesomeAssertions.
        /// </summary>
        [TestMethod]
        public void AreEquivalent_DifferentListOfObjectsWithComplexChildrenButDifferentValueIsInIgnoredProperty_TestFailsBecauseIgnoringPropertiesIsNotSupported()
        {
            // Arrange
            var expected = new List<PersonInternal>
            {
                new PersonInternal("John", "Doe", 30, new AddressInternal("123 Main St", "Anytown", "CA", "12345")),
                new PersonInternal("Jane", "Smith", 25, new AddressInternal("456 Elm St", "Othertown", "NY", "67890")),
                new PersonInternal("Bob", "Johnson", 40, new AddressInternal("789 Oak St", "Sometown", "TX", "54321"))
            };

            var actual = expected.Select(a => a.CreateCopy()).ToList();
            actual[1].Address.Street = "999 Pine St";

            // Act & Assert
            Assert.AreEquivalent(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_ExpectedHasExtraProperty_AssertionFails()
        {
            // Arrange
            var expected = new AddressWithExtraProperty("123 Main St", "Anytown", "CA", "12345", "The Country");
            var actual = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            // Act
            var act = () => Assert.AreEquivalent<object>(expected, actual);

            // Assert
            var ex = Assert.ThrowsExactly<AssertFailedException>(act);
            StringAssert.Contains(ex.Message, "Country");
        }

        [TestMethod]
        public void AreEquivalent_ActualHasExtraProperty_Success()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = new AddressWithExtraProperty("123 Main St", "Anytown", "CA", "12345", "The Country");

            // Act & Assert
            Assert.AreEquivalent<object>(expected, actual);
        }

        [TestMethod]
        public void AreEquivalent_ActualHasExtraPropertyAndComparisonIsStrict_AssertionFails()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = new AddressWithExtraProperty("123 Main St", "Anytown", "CA", "12345", "The Country");

            var strict = true;

            // Act
            var act = () => Assert.AreEquivalent<object>(expected, actual, strict);

            // Assert
            var ex = Assert.ThrowsExactly<AssertFailedException>(act);
            StringAssert.Contains(ex.Message, "Country");
        }
    }
}
