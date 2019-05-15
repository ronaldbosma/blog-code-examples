using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using UsingPronounsInSpecFlowScenarios.Models;

namespace UsingPronounsInSpecFlowScenarios.UnitTests
{
    [TestClass]
    public class PersonStepArgumentTransformationsTests
    {
        #region Test Setup & Teardown

        private PersonStepArgumentTransformations _sut;

        [TestInitialize]
        public void TestInitialize()
        {
            _sut = new PersonStepArgumentTransformations();
        }

        #endregion

        #region ConvertNameToPerson Tests

        [TestMethod]
        public void ConvertNameToPerson_FirstTimeConvertingName_NewPersonCreatedWithName()
        {
            //Arrange
            var newName = "John H. Watson";

            //Act
            var result = _sut.ConvertNameToPerson(newName);

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(newName, result.Name);
        }

        [TestMethod]
        public void ConvertNameToPerson_ConvertSameNameMultipleTimes_SamePersonReturned()
        {
            //Arrange
            var newName = "John H. Watson";

            //Act
            var result1 = _sut.ConvertNameToPerson(newName);
            var result2 = _sut.ConvertNameToPerson(newName);
            var result3 = _sut.ConvertNameToPerson(newName);

            //Assert
            AssertAllPersonsAreSame(result1, result2, result3);
        }

        [TestMethod]
        public void ConvertNameToPerson_DifferentNames_DifferentPersonsCreated()
        {
            //Arrange
            var newName1 = "John H. Watson";
            var newName2 = "Mary Morstan";

            //Act
            var result1 = _sut.ConvertNameToPerson(newName1);
            var result2 = _sut.ConvertNameToPerson(newName2);

            //Assert
            Assert.IsNotNull(result1);
            Assert.IsNotNull(result2);
            Assert.AreNotSame(result1, result2);
        }

        #endregion

        #region ConvertTwoPersonsIntoCollection Tests

        [TestMethod]
        public void CombineTwoPersonsIntoArray_TwoPersons_ArrayWithBothPersonsReturned()
        {
            //Arrange
            var person1 = new Person();
            var person2 = new Person();

            //Act
            var result = _sut.CombineTwoPersonsIntoArray(person1, person2);

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(2, result.Length);
            Assert.AreSame(person1, result[0]);
            Assert.AreSame(person2, result[1]);
        }

        #endregion

        #region ConvertHeToPerson Tests

        [TestMethod]
        public void ConvertHeToPerson_APersonWasAlreadyCreated_PersonReturned()
        {
            //Arrange
            var person = _sut.ConvertNameToPerson("John H. Watson");

            //Act
            var result = _sut.ConvertHeToPerson("dummy");

            //Assert
            Assert.AreSame(person, result);
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException), "Unable to convert '{dummy}' to person. No available person was found.")]
        public void ConvertHeToPerson_NoPersonWasCreatedYet_InvalidOperationException()
        {
            _sut.ConvertHeToPerson("dummy");
        }

        [TestMethod]
        public void ConvertHeToPerson_CalledMultipleTimes_SamePersonReturned()
        {
            //Arrange
            var person = _sut.ConvertNameToPerson("John H. Watson");

            var result1 = _sut.ConvertHeToPerson("he");
            var result2 = _sut.ConvertHeToPerson("him");

            //Act
            var result3 = _sut.ConvertHeToPerson("his");

            //Assert
            AssertAllPersonsAreSame(person, result1, result2, result3);
        }

        [TestMethod]
        public void ConvertHeToPerson_PersonWasCreatedAfterAHeWasAlreadyConverted_OriginalHeWasReturnedAndNotNewPerson()
        {
            //Arrange
            var person = _sut.ConvertNameToPerson("John H. Watson");

            var result1 = _sut.ConvertHeToPerson("he");
            var anotherPerson = _sut.ConvertNameToPerson("Mary Morstan");

            //Act
            var result2 = _sut.ConvertHeToPerson("him");

            //Assert
            AssertAllPersonsAreSame(person, result1, result2);
            Assert.AreNotSame(anotherPerson, result2);
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException), "Unable to convert 'him' to person. No available person was found.")]
        public void ConvertHeToPerson_OnePersonWasCreatedButThatPersonWasAlreadyConvertedToShe_InvalidOperationException()
        {
            //Arrange
            _sut.ConvertNameToPerson("Mary Morstan");
            _sut.ConvertSheToPerson("she");

            //Act
            _sut.ConvertHeToPerson("he");
        }

        #endregion

        #region ConvertSheToPerson Tests

        [TestMethod]
        public void ConvertSheToPerson_APersonWasAlreadyCreated_PersonReturned()
        {
            //Arrange
            var person = _sut.ConvertNameToPerson("Mary Morstan");

            //Act
            var result = _sut.ConvertSheToPerson("dummy");

            //Assert
            Assert.AreSame(person, result);
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException), "Unable to convert '{dummy}' to person. No available person was found.")]
        public void ConvertSheToPerson_NoPersonWasCreatedYet_InvalidOperationException()
        {
            _sut.ConvertSheToPerson("dummy");
        }

        [TestMethod]
        public void ConvertSheToPerson_CalledMultipleTimes_SamePersonReturned()
        {
            //Arrange
            var person = _sut.ConvertNameToPerson("Mary Morstan");

            var result1 = _sut.ConvertSheToPerson("she");
            var result2 = _sut.ConvertSheToPerson("her");

            //Act
            var result3 = _sut.ConvertSheToPerson("hers");

            //Assert
            AssertAllPersonsAreSame(person, result1, result2, result3);
        }

        [TestMethod]
        public void ConvertSheToPerson_PersonWasCreatedAfterAHeWasAlreadyConverted_OriginalHeWasReturnedAndNotNewPerson()
        {
            //Arrange
            var person = _sut.ConvertNameToPerson("Mary Morstan");

            var result1 = _sut.ConvertSheToPerson("she");
            var anotherPerson = _sut.ConvertNameToPerson("John H. Watson");

            //Act
            var result2 = _sut.ConvertSheToPerson("her");

            //Assert
            AssertAllPersonsAreSame(person, result1, result2);
            Assert.AreNotSame(anotherPerson, result2);
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException), "Unable to convert 'her' to person. No available person was found.")]
        public void ConvertSheToPerson_OnePersonWasCreatedButThatPersonWasAlreadyConvertedToShe_InvalidOperationException()
        {
            //Arrange
            _sut.ConvertNameToPerson("John H. Watson");
            _sut.ConvertHeToPerson("he");

            //Act
            _sut.ConvertSheToPerson("she");
        }

        #endregion

        #region Private Methods

        private void AssertAllPersonsAreSame(params Person[] persons)
        {
            var firstPerson = persons.First();

            Assert.IsNotNull(firstPerson);

            foreach (var person in persons.Skip(1))
            {
                Assert.AreSame(firstPerson, person);
            }
        }

        #endregion
    }
}
