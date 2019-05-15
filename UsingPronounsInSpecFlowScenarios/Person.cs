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

        public static void MoveInTogether(Person p1, Person p2, string newAddress)
        {
            p1.Address = newAddress;
            p2.Address = newAddress;
        }
    }
}
