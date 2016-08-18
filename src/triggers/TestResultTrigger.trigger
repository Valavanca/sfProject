trigger TestResultTrigger on TestResult__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  
	public TestResultTriggerHandler handler = new TestResultTriggerHandler(Trigger.oldMap, Trigger.newMap, Trigger.old, Trigger.new); 

  if (Trigger.isBefore){ 
	 
		if (Trigger.isDelete) {} 
			else 
		if (Trigger.isInsert) {
		handler.bulkBefore();
		for (SObject so : Trigger.new) handler.beforeInsert(so);
		}
			else 
		if (Trigger.isUpdate){}
			 
			}else { 
		if (Trigger.isDelete){} 
			else 
		if (Trigger.isInsert) {}
			else 
		if (Trigger.isUpdate){}
		 
	}


	
	
}