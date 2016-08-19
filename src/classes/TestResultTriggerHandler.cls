public class TestResultTriggerHandler extends TriggerHandler  implements ITrigger{
		private static final Id OTHER_GUEST_ID = 'a0458000005QFWX';
	
		public static Map<String,Id> emailToIdUserMap = new Map<String,Id>();
		public static Map<String,Set<String>> existTestNameToStudent = new Map<String,Set<String>>();

		public TestResultTriggerHandler(Map<Id, SObject> old_map, Map<Id, SObject> new_map, 
		List<SObject> old_list, List<SObject> new_list) { 
			super(old_map, new_map, old_list, new_list); 
		} 
	
	public void beforeInsert(SObject so) {
		createTestResult((TestResult__c)so);
	}	
	public void beforeUpdate(SObject oldSo, SObject so) {} 
	public void beforeDelete(SObject so) {} 
	public void afterInsert(SObject so) {} 
	public void afterUpdate(SObject oldSo, SObject so) {} 
	public void afterDelete(SObject so) {} 
	public void bulkBefore(){
		selectInformOfNewTestResult();
	}
	public void bulkAfter(){}
	public void andFinally(){}
	public void removeEvent(){}

	// HELP METHODS

	private void selectInformOfNewTestResult(){
		Set<String> userEmailSet = new Set<String>();
		Set<String> existTest = new Set<String>();
		for(SObject so: newList){
			TestResult__c currentTestResult = (TestResult__c)so;
			userEmailSet.add(currentTestResult.Email__c);
			existTest.add(currentTestResult.Name);
		}
		for(User_Course_Profile__c currentUserProfile : [SELECT Email__c, Name 
														 FROM User_Course_Profile__c 
														 WHERE Email__c IN :userEmailSet]){
			emailToIdUserMap.put(currentUserProfile.Email__c, currentUserProfile.Id);
		}

		for(TestResult__c currentTestResult: [SELECT Name,Email__c
											  FROM TestResult__c 
											  WHERE Name IN :existTest]){
			if(existTestNameToStudent.keySet().contains(currentTestResult.Name)){
				if(existTestNameToStudent.get(currentTestResult.Name) != null){
					existTestNameToStudent.get(currentTestResult.Name).add(currentTestResult.Email__c);
				}else {
					existTestNameToStudent.put(currentTestResult.Name, new Set<String>());
					existTestNameToStudent.get(currentTestResult.Name).add(currentTestResult.Email__c);
				}
			}else {
				existTestNameToStudent.put(currentTestResult.Name, new Set<String>());
				existTestNameToStudent.get(currentTestResult.Name).add(currentTestResult.Email__c);
			}
		}

	}

	private void createTestResult(TestResult__c currentTestResult){
		if((existTestNameToStudent.keySet().contains(currentTestResult.Name)) &&
			(existTestNameToStudent.get(currentTestResult.Name).contains(currentTestResult.Email__c))){
				currentTestResult.addError(Constants.ERROR_RESULT_EXIST);
			}
		if(emailToIdUserMap.keySet().contains(currentTestResult.Email__c)){
			currentTestResult.User_Course_Profile__c = emailToIdUserMap.get(currentTestResult.Email__c);
		} else {
			currentTestResult.User_Course_Profile__c = OTHER_GUEST_ID;
		}
	}

 }