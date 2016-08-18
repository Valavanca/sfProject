public class KnowledgeCheckResultsController {
	public String testName {get; set;}
	public List<resultWrapper> resultThisDayList {get; set;}
	public KnowledgeCheckResultsController(){
		resultThisDayList = new List<resultWrapper>();
	}

	public void showTestResult(){
		for(TestResult__c currentTestResult:[SELECT FirstName__c, LastName__c, Percentage__c FROM TestResult__c WHERE Name = :testName ORDER BY Percentage__c DESC]){
			resultThisDayList.add(new resultWrapper(currentTestResult.FirstName__c,currentTestResult.LastName__c,currentTestResult.Percentage__c));
		}
		resultThisDayList.sort();

	}

	public class resultWrapper implements Comparable{
		public String FirstName {get; set;}
		public String LastName {get; set;}
		public String Percentage {get; set;}

		public resultWrapper(String FirstName, String LastName, String Percentage){
			this.FirstName = FirstName;
			this.LastName = LastName;
			this.Percentage= Percentage;
		}
	    
    public Integer compareTo(Object compareTo) {
        resultWrapper compareToResul = (resultWrapper)compareTo;
        if (Percentage == compareToResul.Percentage) return 0;
        if (Percentage > compareToResul.Percentage) return 1;
        return -1;        
    }


	}
 }