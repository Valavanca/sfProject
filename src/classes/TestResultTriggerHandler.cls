public class TestResultTriggerHandler extends TriggerHandler  implements ITrigger{
		private static final Id OTHER_GUEST_ID = 'a0458000005QFWX';
		public static Set<String> userEmailSet = new Set<String>();
		public static Map<String,Id> emailToIdUserMap = new Map<String,Id>();

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
		findExistUserProfile();
	}
	public void bulkAfter(){}
	public void andFinally(){}
	public void removeEvent(){}

	// HELP METHODS
	private void findExistUserProfile(){
		selectUserProfileEmail();
		selectUserProfile();
	}
	private void selectUserProfileEmail(){
		for(SObject so: newList){
			TestResult__c currentTestResult = (TestResult__c)so;
			userEmailSet.add(currentTestResult.Email__c);
		}
	}

	private void selectUserProfile(){
		for(User_Course_Profile__c currentUserProfile : [SELECT Email__c, Name FROM User_Course_Profile__c WHERE Email__c IN :userEmailSet]){
			emailToIdUserMap.put(currentUserProfile.Email__c, currentUserProfile.Id);
		}
	}

	private void createTestResult(TestResult__c currentTestResult){
		if(emailToIdUserMap.keySet().contains(currentTestResult.Email__c)){
			currentTestResult.User_Course_Profile__c = emailToIdUserMap.get(currentTestResult.Email__c);
		} else {
			currentTestResult.User_Course_Profile__c = OTHER_GUEST_ID;
		}
	}

 }