using NUnit.Framework;

namespace Traks.Tests
{
    public class Tests
    {
        public bool Nothing { get; set; }

        [SetUp]
        public void Setup()
        {
            Nothing = true;
        }

        [Test]
        public void Test1()
        {
            Assert.Equals(Nothing, true);
        }
    }
}