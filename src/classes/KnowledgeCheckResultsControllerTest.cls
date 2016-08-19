@isTest
public class KnowledgeCheckResultsControllerTest {
	@isTest
	public static void testNullResult(){
		Test.startTest();
		KnowledgeCheckResultsController tester = new KnowledgeCheckResultsController();
		Test.stopTest();
		System.assertEquals(false,tester.showResultTable);
		System.assertEquals(false,tester.showResultBlock);
		System.assertEquals(tester.resultThisDayList.size(), [SELECT COUNT() FROM TestResult__c]);
	}

	private class TestDataGenerator extends CloneMaker{
		
	}
 }