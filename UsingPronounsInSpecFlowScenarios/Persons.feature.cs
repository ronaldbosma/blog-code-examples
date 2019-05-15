// ------------------------------------------------------------------------------
//  <auto-generated>
//      This code was generated by SpecFlow (http://www.specflow.org/).
//      SpecFlow Version:3.0.0.0
//      SpecFlow Generator Version:3.0.0.0
// 
//      Changes to this file may cause incorrect behavior and will be lost if
//      the code is regenerated.
//  </auto-generated>
// ------------------------------------------------------------------------------
#region Designer generated code
#pragma warning disable
namespace UsingPronounsInSpecFlowScenarios
{
    using TechTalk.SpecFlow;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("TechTalk.SpecFlow", "3.0.0.0")]
    [System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [Microsoft.VisualStudio.TestTools.UnitTesting.TestClassAttribute()]
    public partial class PersonsFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
        private Microsoft.VisualStudio.TestTools.UnitTesting.TestContext _testContext;
        
#line 1 "Persons.feature"
#line hidden
        
        public virtual Microsoft.VisualStudio.TestTools.UnitTesting.TestContext TestContext
        {
            get
            {
                return this._testContext;
            }
            set
            {
                this._testContext = value;
            }
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassInitializeAttribute()]
        public static void FeatureSetup(Microsoft.VisualStudio.TestTools.UnitTesting.TestContext testContext)
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Persons", "\tContains scenario\'s using pronouns", ProgrammingLanguage.CSharp, ((string[])(null)));
            testRunner.OnFeatureStart(featureInfo);
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassCleanupAttribute()]
        public static void FeatureTearDown()
        {
            testRunner.OnFeatureEnd();
            testRunner = null;
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestInitializeAttribute()]
        public virtual void TestInitialize()
        {
            if (((testRunner.FeatureContext != null) 
                        && (testRunner.FeatureContext.FeatureInfo.Title != "Persons")))
            {
                global::UsingPronounsInSpecFlowScenarios.PersonsFeature.FeatureSetup(null);
            }
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCleanupAttribute()]
        public virtual void ScenarioTearDown()
        {
            testRunner.OnScenarioEnd();
        }
        
        public virtual void ScenarioInitialize(TechTalk.SpecFlow.ScenarioInfo scenarioInfo)
        {
            testRunner.OnScenarioInitialize(scenarioInfo);
            testRunner.ScenarioContext.ScenarioContainer.RegisterInstanceAs<Microsoft.VisualStudio.TestTools.UnitTesting.TestContext>(_testContext);
        }
        
        public virtual void ScenarioStart()
        {
            testRunner.OnScenarioStart();
        }
        
        public virtual void ScenarioCleanup()
        {
            testRunner.CollectScenarioErrors();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("John and Mary move in together using names")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "Persons")]
        public virtual void JohnAndMaryMoveInTogetherUsingNames()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("John and Mary move in together using names", null, ((string[])(null)));
#line 4
this.ScenarioInitialize(scenarioInfo);
            this.ScenarioStart();
#line 6
 testRunner.Given("a man called \'John H. Watson\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 7
        testRunner.And("a woman called \'Mary Morstan\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 8
        testRunner.And("\'John H. Watson\' lives at \'221B Baker Street, London\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 9
        testRunner.And("\'Mary Morstan\' lives at \'123 Couldn\'t Find It, London\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 10
    testRunner.When("\'John H. Watson\' and \'Mary Morstan\' move in together at \'221B Baker Street, Londo" +
                    "n\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 11
    testRunner.Then("\'John H. Watson\' his address is \'221B Baker Street, London\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 12
        testRunner.And("\'Mary Morstan\' her address is \'221B Baker Street, London\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("John and Mary move in together using pronouns")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "Persons")]
        public virtual void JohnAndMaryMoveInTogetherUsingPronouns()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("John and Mary move in together using pronouns", null, ((string[])(null)));
#line 15
this.ScenarioInitialize(scenarioInfo);
            this.ScenarioStart();
#line 17
 testRunner.Given("a man called \'John H. Watson\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 18
        testRunner.And("a woman called \'Mary Morstan\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 19
        testRunner.And("he lives at \'221B Baker Street, London\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 20
        testRunner.And("she lives at \'123 Couldn\'t Find It, London\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 21
    testRunner.When("they move in together at \'221B Baker Street, London\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 22
    testRunner.Then("his address is \'221B Baker Street, London\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 23
        testRunner.And("her address is \'221B Baker Street, London\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
