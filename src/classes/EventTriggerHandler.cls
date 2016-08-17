public class EventTriggerHandler  extends TriggerHandler  implements ITrigger{
	
	public static List<Event__c> eventList = new List<Event__c>();
	public static Map<Date,List<Event__c>> eventsByDays = new Map<Date,List<Event__c>>();
	public static Map<Id,Event__c> deleteMap = new Map<Id,Event__c> ();

		public EventTriggerHandler(Map<Id, SObject> old_map, Map<Id, SObject> new_map, 
		List<SObject> old_list, List<SObject> new_list) { 
			super(old_map, new_map, old_list, new_list); 
		} 
	
	public void beforeInsert(SObject so) {
		checkBusyTime((Event__c)so);
	}	
	public void beforeUpdate(SObject oldSo, SObject so) {
		checkBusyTime((Event__c)so);
	} 
	public void beforeDelete(SObject so) {} 
	public void afterInsert(SObject so) {} 
	public void afterUpdate(SObject oldSo, SObject so) {} 
	public void afterDelete(SObject so) {} 
	public void bulkBefore(){
		Set<Date> eventDateSet = new Set<Date>();
		for(SObject so :NewList){
			Event__c currentEvent = (Event__c)so;
			eventDateSet.add(currentEvent.Date__c);
		}
		eventList = [SELECT Id, Start_datetime__c, Finish_datetime__c, Date__c,Type__c, Name FROM Event__c WHERE Date__c IN :eventDateSet];
		
		addEventsByDays();
	}
	public void bulkAfter(){}
	public void andFinally(){}
	public void removeEvent(){
		List<Event__c> deleteList = new List<Event__c>(deleteMap.values());
		delete deleteList;
	}
	

	//HELP METHODS
	
	private void addEventsByDays(){
		for(Event__c currentEvent: eventList){
		if(eventsByDays.keySet().contains(currentEvent.Date__c)){
				eventsByDays.get(currentEvent.Date__c).add(currentEvent);
			}else {
				eventsByDays.put(currentEvent.Date__c,new List<Event__c>());
				eventsByDays.get(currentEvent.Date__c).add(currentEvent);
			}
			}
	}



	private void checkBusyTime(Event__c currentEvent){
		List<Event__c> currentDeleteList = new List<Event__c>();

		if(eventsByDays.containsKey(currentEvent.Date__c))
		for(Integer i = eventsByDays.get(currentEvent.Date__c).size() - 1; i >= 0; i--){
			
			if(checkintersectionEvents(currentEvent,eventsByDays.get(currentEvent.Date__c)[i])){
				if(checkPossibilityOfReplacingEvent(currentEvent.Type__c, eventsByDays.get(currentEvent.Date__c)[i].Type__c)){
					if(eventsByDays.get(currentEvent.Date__c)[i].Id != null){
							currentDeleteList.add(eventsByDays.get(currentEvent.Date__c)[i]);
						}
					eventsByDays.get(currentEvent.Date__c).remove(i);
				} else {
					currentEvent.addError(Constants.ERROR_TIME_IS_BUSY);
				}
			}
		}

		deleteMap.putAll(currentDeleteList);
		if(eventsByDays.get(currentEvent.Date__c) != null){
		eventsByDays.get(currentEvent.Date__c).add(currentEvent);
		}else {
		eventsByDays.put(currentEvent.Date__c,new List<Event__c>() );
		eventsByDays.get(currentEvent.Date__c).add(currentEvent);
		}
	}

	private static Boolean checkPossibilityOfReplacingEvent(String currentEvent, String existingEvent){
		if((Constants.HIGHT_PRIORITY_EVENT_TYPE.contains(currentEvent)) 
		&&(!Constants.HIGHT_PRIORITY_EVENT_TYPE.contains(existingEvent))){
		//if((currentEvent != 'Recreation') && (existingEvent == 'Recreation')){
			return true;
		}
		return false;
	}

	private Boolean checkIntersectionEvents(Event__c currentEvent, Event__c existingEvent){
		if(currentEvent.Id == existingEvent.Id) return false;
		if((currentEvent.Start_datetime__c > existingEvent.Finish_datetime__c) 
			|| (currentEvent.Finish_datetime__c < existingEvent.Start_datetime__c)){
				return false;
			}
			return true;
	}
 }