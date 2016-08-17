public class EmeilSendTeachers implements Schedulable { 
	public void execute(SchedulableContext SC) {
		List<Event__c> eventToday = [SELECT Id, Teacher__c, Finish_datetime__c, 	Start_datetime__c, 	Topic__c,Type__c 
									FROM Event__c WHERE Date__c = :Date.today() AND Teacher__c != null];
		Set<Id> teachersId = new Set<Id>();
		for (Event__c currentEvent: eventToday){
			teachersId.add(currentEvent.Teacher__c);
		}
		Map<Id,User> teacherMap = new Map<Id,User>([SELECT Id, Email, Name FROM User WHERE Id IN :teachersId]);
		for (Event__c currentEvent: eventToday){
			sentEmail(teacherMap.get(currentEvent.Teacher__c), currentEvent);
		}
		



	}

	private static void sentEmail(User currentTeacher, Event__c currentEvent){		
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
			String[] toAddresses = new String[] {currentTeacher.Email};  
			mail.setToAddresses(toAddresses);  
			mail.setSubject('Reminder about tomorrow\'s event');  
			mail.setPlainTextBody('Dear, ' + currentTeacher.Name + ' tomorrow you are responsible for any event ' 
																 + currentEvent.Name 
																 + '. Starting at '
																 + currentEvent.Start_datetime__c.time()
																 + ', finish at '
																 + currentEvent.Finish_datetime__c.time());  
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});  
	}
}