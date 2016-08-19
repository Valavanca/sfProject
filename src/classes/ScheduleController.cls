public class ScheduleController {
    public  List<Event__c> eventOfDayList {get; set;}
	public  List<WAttendance> wAttendanceList {get; set;}
	public  Date dateForSchedule {get; set;}
	public  Boolean eventToday {get; set;}
	public  Boolean showError {get; set;}
	List<Event__c> allEventInDate;
    public ScheduleController(){
		dateForSchedule = Date.today();		
		
        scheduleMaker(dateForSchedule);
		makeVisitReport(dateForSchedule);
    }

	public  void showSchedule(){
		scheduleMaker(dateForSchedule);
		makeVisitReport(dateForSchedule);
	}

    private  void scheduleMaker(Date currentDay){
        eventOfDayList = [SELECT Id, Name, Start_datetime__c, Finish_datetime__c, Teacher__r.Name, Topic__c 
						  FROM Event__c 
						  WHERE Date__c = :currentDay 
						  ORDER BY Start_datetime__c ASC];
		if(eventOfDayList.size() != 0){
			eventToday = true;
			showError = false;
		} else {
			eventToday = false;
			showError = true;
		}
    }
	

	private  void makeVisitReport(Date currentDay){
		wAttendanceList = new List<WAttendance>();
		for(AggregateResult ar: [SELECT COUNT(EventId__c), UserId__r.Name 
								 FROM UserAtTheEvent__c 
								 WHERE EventId__c IN :eventOfDayList 
								 GROUP BY UserId__r.Name]){
			wAttendanceList.add(new WAttendance((Integer)ar.get('expr0'),(String)ar.get('Name')));
		}
	}

	public class WAttendance{
		public Integer numberOfVisit {get;set;}
		public String nameStudent {get;set;}
		public WAttendance(Integer numberOfVisit, String nameStudent){
			this.numberOfVisit = numberOfVisit;
			this.nameStudent = nameStudent;
		}
	}
	
	}