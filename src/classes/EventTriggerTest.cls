@isTest
public class EventTriggerTest {
	@isTest
	static void testInsertEvent(){
		Integer quantity = 1;
		DateTime startTimeForEvent = DateTime.newInstanceGMT(2016, 08, 16, 10, 0, 0);
		TestDataGenerator dateGenerator = new TestDataGenerator();
		List<Event__c> eventList = dateGenerator.createEventList(quantity, dateGenerator.generateEventLesson(startTimeForEvent));

		Test.startTest();
		insert eventList;
		Test.stopTest();
		System.assertEquals(quantity,[SELECT COUNT() FROM Event__c]);
	}

	@isTest
	static void testInsertEventLowPriority(){
		Integer quantity = 1;
		Integer quantityBulk = 200;
		DateTime startTimeForEvent = DateTime.newInstanceGMT(2016, 08, 16, 10, 0, 0);
		TestDataGenerator dateGenerator = new TestDataGenerator();
		List<Event__c> eventListFirst = dateGenerator.createEventList(quantity, dateGenerator.generateEventLesson(startTimeForEvent));
		List<Event__c> eventListSecond = dateGenerator.createEventList(quantityBulk, dateGenerator.generateEventLesson(startTimeForEvent), dateGenerator.generateEventRecreation(startTimeForEvent));
		insert eventListFirst;

		Test.startTest();
		try{
		insert eventListSecond;
		}catch(Exception e){}
		Test.stopTest();

		System.assertEquals(quantity,[SELECT COUNT() FROM Event__c]);
	}

	@isTest
	static void testInsertEventHightPriorityBulk(){
		Integer quantity = 1;
		Integer quantityBulk = 200;
		DateTime startTimeForEvent = DateTime.newInstanceGMT(2016, 08, 16, 10, 0, 0);
		TestDataGenerator dateGenerator = new TestDataGenerator();
		List<Event__c> eventListFirst = dateGenerator.createEventList(quantityBulk, dateGenerator.generateEventRecreation(startTimeForEvent));
		List<Event__c> eventListSecond = dateGenerator.createEventList(quantityBulk, dateGenerator.generateEventLesson(startTimeForEvent));
		dateGenerator.insertSpacesTime(2,eventListFirst);
		dateGenerator.insertSpacesTime(2,eventListSecond);
		insert eventListFirst;
		for (Integer i = 0; i < 200; i++ ){
			System.debug(eventListFirst[i].Id);
			System.debug(eventListSecond[i].Id);
		}
		Test.startTest();
		insert eventListSecond;
		Test.stopTest();

		System.assertEquals(quantityBulk,[SELECT COUNT() FROM Event__c]);
		System.assertEquals(0,[SELECT COUNT() FROM Event__c WHERE Type__c = 'Recreation']);
	}

	@isTest
	static void testInsertEventDifferentPriorityBulk(){
		Integer quantity = 1;
		Integer quantityBulk = 200;
		DateTime startTimeForEvent = DateTime.newInstanceGMT(2016, 08, 16, 10, 0, 0);
		TestDataGenerator dateGenerator = new TestDataGenerator();
		List<Event__c> eventListFirst = dateGenerator.createEventList(quantityBulk, dateGenerator.generateEventRecreation(startTimeForEvent),dateGenerator.generateEventLesson(startTimeForEvent));
		startTimeForEvent = startTimeForEvent.addHours(1);
		List<Event__c> eventListSecond = dateGenerator.createEventList(quantityBulk, dateGenerator.generateEventLesson(startTimeForEvent));
		dateGenerator.insertSpacesTime(2,eventListFirst);
		dateGenerator.insertSpacesTime(2,eventListSecond);
		insert eventListFirst;
		for (Integer i = 0; i < 200; i++ ){
			System.debug(eventListFirst[i].Id);
			System.debug(eventListSecond[i].Id);
		}
		Test.startTest();
		try{
		insert eventListSecond;
		}catch(Exception e){}
		Test.stopTest();

		System.assertEquals(quantityBulk,[SELECT COUNT() FROM Event__c]);
		System.assertEquals(100,[SELECT COUNT() FROM Event__c WHERE Type__c = 'Recreation']);
	}

	@isTest
	static void testUpdateEventBulk(){
		Integer quantity = 200;
		DateTime startTimeForEvent = DateTime.newInstanceGMT(2016, 08, 16, 10, 0, 0);
		TestDataGenerator dateGenerator = new TestDataGenerator();
		List<Event__c> eventList = dateGenerator.createEventList(quantity, dateGenerator.generateEventLesson(startTimeForEvent));
		dateGenerator.insertSpacesTime(2,eventList);
		insert eventList;
		for(Event__c currentEvent: eventList){
			currentEvent.Name = 'test';
		}
		Test.startTest();
		update eventList;
		Test.stopTest();
		System.assertEquals(quantity,[SELECT COUNT() FROM Event__c WHERE Name = 'test']);
	}

	private class TestDataGenerator{
		
		private List<Event__c> createEventList (Integer quantity, Event__c exemplarEvent){
			List<Event__c> eventList = new List<Event__c>();
			for (Integer i = 0; i < quantity; i++){
				eventList.add(exemplarEvent.clone(false,true,true,true)); 
			}
			return eventList;
		}

		private List<Event__c> createEventList (Integer quantity, Event__c exemplarEventFirst, Event__c exemplarEventSecond){
			List<Event__c> eventList = new List<Event__c>();
			for (Integer i = 0; i < quantity; i++){
				if(Math.mod(i,2) == 0){
				eventList.add(exemplarEventFirst.clone(false,true,true,true)); 
				} else{
				eventList.add(exemplarEventSecond.clone(false,true,true,true)); 
				}
			}
			return eventList;
		}

		private Event__c generateEventLesson(Datetime startTime){
			Event__c exemplarEvent =  EventBuilder.getEvent()
												   .setName('Lesson')
												   .setStartDatetime(startTime)
												   .setFinishDatetime(startTime.addHours(1))
												   .setType('Lesson')
												   .setTopic('SF')
												   .setTeacher(Constants.USER_SASHA_KEROV_ID)
												   .getRecord();
			return exemplarEvent;
		}

		private Event__c generateEventRecreation(Datetime startTime){
			Event__c exemplarEvent =  EventBuilder.getEvent()
												   .setName('Recreation')
												   .setStartDatetime(startTime)
												   .setFinishDatetime(startTime.addHours(1))
												   .setType('Recreation')
												   .setTopic('PC Game')
												   .setTeacher(Constants.USER_SASHA_KEROV_ID)
												   .getRecord();
			return exemplarEvent;
		}

		private void insertSpacesTime(Integer quantityHours, List<Event__c> currentEventList){
			Integer counter = 0;
			for(Event__c currentEvent: currentEventList){
				currentEvent.Start_datetime__c = currentEvent.Start_datetime__c.addHours(counter);
				currentEvent.Finish_datetime__c = currentEvent.Finish_datetime__c.addHours(counter);
				counter += quantityHours;
			}
		}
		
	}
 }