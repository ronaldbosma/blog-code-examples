using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsingPronounsInSpecFlowScenarios
{
    class Person
    {
        public string Name { get; set; }

        public Gender Gender { get; set; }

        public string Address { get; set; }

        public static void MoveInTogether(string newAddress, params Person[] persons)
        {
            foreach (var person in persons)
            {
                person.Address = newAddress;
            }
        }
    }
}
