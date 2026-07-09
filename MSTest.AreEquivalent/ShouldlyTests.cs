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
            act.ShouldThrow<ShouldAssertException>().Message.ShouldContain("Street");
        }


        /// <summary>
        /// This test will currently fail because Shouldly does not support comparing objects of different types in the ShouldBeEquivalentTo assertion.
        /// This scenario is supported by AwesomeAssertions and MSTest.
        /// </summary>
        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfDifferentTypeButWithSameValues_TestFailsBecauseOfDifferentTypesAlthoughObjectsAreEquivalent()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");
            var actual = expected.MapToExternal();

            // Act & Assert
            actual.ShouldBeEquivalentTo(expected);
        }

        /// <summary>
        /// This test will currently fail because Shouldly does not support comparing objects of different types in the ShouldBeEquivalentTo assertion.
        /// In this case it will throw a 'ShouldAssertException' as expected, but the reason is the different types instead of the Street property having different values.
        /// This scenario is supported by AwesomeAssertions and MSTest.
        /// </summary>
        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualAreDifferentObjectsOfDifferentTypeWithDifferentValues_TestFailsBecauseOfDifferentTypesAndNotBecauseOfDifferentValues()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.MapToExternal();
            actual.Street = "456 Elm St";

            // Act
            var act = () => actual.ShouldBeEquivalentTo(expected);

            // Assert
            act.ShouldThrow<ShouldAssertException>().Message.ShouldContain("Street");
        }

        /// <summary>
        /// This test will currently fail because Shouldly does not support comparing objects of different types in the ShouldBeEquivalentTo assertion.
        /// This scenario is supported by AwesomeAssertions and MTest.
        /// </summary>
        [TestMethod]
        public void ShouldBeEquivalentTo_EquivalentComplexObjectsOfDifferentTypes_TestFailsBecauseOfDifferentTypesAlthoughObjectsAreEquivalent()
        {
            // Arrange
            var expected = new PersonInternal("John", "Doe", 30,
                new AddressInternal("123 Main St", "Anytown", "CA", "12345"));
            var actual = expected.MapToExternal();

            // Act & Assert
            actual.ShouldBeEquivalentTo(expected);
        }

        /// <summary>
        /// This test will currently fail because Shouldly does not support comparing objects of different types in the ShouldBeEquivalentTo assertion.
        /// In this case it will throw a 'ShouldAssertException' as expected, but the reason is the different types instead of the Street property having different values.
        /// This scenario is supported by AwesomeAssertions and MSTest.
        /// </summary>
        [TestMethod]
        public void AreEquivalent_EquivalentComplexObjectsOfDifferentTypesWithDifferentValueInChildObject_TestFailsBecauseOfDifferentTypesAlthoughObjectsAreEquivalent()
        {
            // Arrange
            var expected = new PersonInternal("John", "Doe", 30,
                new AddressInternal("123 Main St", "Anytown", "CA", "12345"));

            var actual = expected.MapToExternal();
            actual.Address.Street = "456 Elm St";

            // Act
            var act = () => actual.ShouldBeEquivalentTo(expected);

            // Assert
            act.ShouldThrow<ShouldAssertException>().Message.ShouldContain("Street");
        }

        /// <summary>
        /// This test will currently fail because Shouldly does not support ignoring properties in the ShouldBeEquivalentTo assertion.
        /// This scenario is supported by AwesomeAssertions.
        /// </summary>
        [TestMethod]
        public void ShouldBeEquivalentTo_ExpectedAndActualHaveDifferentValueButPropertyIsIgnored_TestFailsBecauseIgnoringPropertiesIsNotSupported()
        {
            // Arrange
            var expected = new AddressInternal("123 Main St", "Anytown", "CA", "12345");

            var actual = expected.CreateCopy();
            actual.Street = "456 Elm St";

            // Act & Assert
            actual.ShouldBeEquivalentTo(expected);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_EquivalentListOfObjects_Success()
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
        public void ShouldBeEquivalentTo_DifferentListOfObjects_AssertionFails()
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
            act.ShouldThrow<ShouldAssertException>().Message.ShouldContain("Street");
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_EquivalentListOfObjectsWithComplexChildren_Success()
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
            actual.ShouldBeEquivalentTo(expected);
        }

        [TestMethod]
        public void ShouldBeEquivalentTo_DifferentListOfObjectsWithComplexChildren_AssertionFails()
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
            var act = () => actual.ShouldBeEquivalentTo(expected);

            // Assert
            act.ShouldThrow<ShouldAssertException>().Message.ShouldContain("Street");
        }

        /// <summary>
        /// This test will currently fail because Shouldly does not support ignoring properties in the ShouldBeEquivalentTo assertion.
        /// This scenario is supported by AwesomeAssertions.
        /// </summary>
        [TestMethod]
        public void ShouldBeEquivalentTo_DifferentListOfObjectsWithComplexChildrenButDifferentValueIsInIgnoredProperty_TestFailsBecauseIgnoringPropertiesIsNotSupported()
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
            actual.ShouldBeEquivalentTo(expected);
        }
    }
}
