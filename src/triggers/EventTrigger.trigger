trigger EventTrigger on Event__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  
	public EventTriggerHandler handler = new EventTriggerHandler(Trigger.oldMap, Trigger.newMap, Trigger.old, Trigger.new); 

  if (Trigger.isBefore){ 
	 
		if (Trigger.isDelete) {} 
			else 
		if (Trigger.isInsert) {
		 handler.bulkBefore();
		for (SObject so : Trigger.new) handler.beforeInsert(so); 
		handler.removeEvent();
		}
			else 
		if (Trigger.isUpdate){ 
		 handler.bulkBefore();
		for (SObject so : Trigger.old) handler.beforeUpdate(so, Trigger.newMap.get(so.Id)); 
		handler.removeEvent();
	}
			 
			}else { 
		if (Trigger.isDelete){} 
			else 
		if (Trigger.isInsert) {}
			else 
		if (Trigger.isUpdate){}
		 
	}
}