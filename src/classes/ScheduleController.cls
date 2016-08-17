public class ScheduleController {
    public static List<Event__c> eventOfDayList {get; set;}
	List<Event__c> allEventInDate;
    public ScheduleController(){
        scheduleMaker(Date.today());
    }

    private static void scheduleMaker(Date currentDay){
        eventOfDayList = [SELECT Id, Name, Start_datetime__c, Finish_datetime__c, Teacher__r.Name, Topic__c FROM Event__c WHERE Date__c = :currentDay ORDER BY Start_datetime__c ASC];
    }
	


	
	}