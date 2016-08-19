public class KnowledgeCheckResultsController {
	private static final String BUTTON_NAME_ASC = 'Sort ascending';
	private static final String BUTTON_NAME_DESC = 'Sort descending';
	public  String testName {get; set;}
	public  String buttonName {get; set;}
	public Boolean showResultTable {get; set;}
	public Boolean showResultBlock {get; set;}
	public  List<resultWrapper> resultThisDayList {get; set;}
	public  Map<String,scoreWrapper> testScoreMap {get; set;}
	public List<scoreWrapper> testScoreList {get; set;}

	public KnowledgeCheckResultsController(){
		showResultTable = false;
		showResultBlock = false;
		testScoreMap = new Map<String,scoreWrapper>();
		buttonName = BUTTON_NAME_ASC;
		showTestResult();
	}

	public void showTestResult(){
		resultThisDayList = new List<resultWrapper>();
		createResult();
		if(resultThisDayList.size() != 0){
		createScore();
		testScoreList = testScoreMap.values();
		showResultTable = true;
		showResultBlock = true;
		}else {
			showResultTable = false;
		}
	}

	private void createResult(){
		for(TestResult__c currentTestResult:[SELECT FirstName__c, LastName__c, Percentage__c 
											 FROM TestResult__c 
											 WHERE Name = :testName ]){
			resultThisDayList.add(new resultWrapper(currentTestResult.FirstName__c,
													currentTestResult.LastName__c,
													currentTestResult.Percentage__c));
		}
	}

	private void createScore(){
		 Decimal averageResult = 0;
		 Decimal bestResult = resultThisDayList[0].Percentage;
		 Decimal worstResult = resultThisDayList[0].Percentage;
		 Integer quantityMember = resultThisDayList.size();
		for(resultWrapper currentResult: resultThisDayList){
			averageResult += currentResult.Percentage;
			if(currentResult.Percentage > bestResult) {
				bestResult = currentResult.Percentage;
				}else{
					if(currentResult.Percentage < worstResult) worstResult = currentResult.Percentage;
			}
		}
		testScoreMap.put(testName, new scoreWrapper(averageResult/quantityMember,bestResult,worstResult,quantityMember,testName));
	}
	
	public  void changeSort(){
		if(buttonName == BUTTON_NAME_ASC){	
			resultThisDayList.sort();
			buttonName = BUTTON_NAME_DESC;
		}else{
			buttonName = BUTTON_NAME_ASC;
			sortResultASC();
		}
	}

	private void sortResultASC(){
		resultThisDayList.sort();
		Integer length = resultThisDayList.size();
		Integer midleLength  = length/2;
		for(Integer i = 0; i < midleLength; i++){
			resultWrapper tmp = resultThisDayList[i];
			resultThisDayList[i] = resultThisDayList[length - 1 - i];
			resultThisDayList[length - 1 - i] = tmp;
		}
	}

	public class resultWrapper implements Comparable{
		public String FirstName {get; set;}
		public String LastName {get; set;}
		public Decimal Percentage {get; set;}

		public resultWrapper(String FirstName, String LastName, String Percentage){
			this.FirstName = FirstName;
			this.LastName = LastName;
			this.Percentage = parsePercentage(Percentage);
		}

		private Decimal parsePercentage(String Percentage){
			Percentage = Percentage.deleteWhitespace().split('%')[0];
			return Decimal.valueOf(Percentage);
		}
	    
    public Integer compareTo(Object compareTo) {
        resultWrapper compareToResul = (resultWrapper)compareTo;
        if (Percentage == compareToResul.Percentage) return 0;
        if (Percentage > compareToResul.Percentage) return -1;
        return 1; 
    }


	}

	public class scoreWrapper{
		public Decimal averageResult {get; set;}
		public Decimal bestResult {get; set;}
		public Decimal worstResult {get; set;}
		public Integer quantityMember {get; set;}
		public String testScoreName {get; set;}

		public scoreWrapper(Decimal averageResult, 
							Decimal bestResult, 
							Decimal worstResult, 
							Integer quantityMember,
							String testScoreName){
			this.averageResult = averageResult.setScale(2);
			this.bestResult = bestResult;
			this.worstResult = worstResult;
			this.quantityMember = quantityMember;
			this.testScoreName = testScoreName;
		}
	}
 }