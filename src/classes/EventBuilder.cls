public class EventBuilder{
	//private String Name;
	//private Datetime Finish_datetime__c; 

    public static Builder getEvent(){
        return new Builder();
    }

    public class Builder{
        private Event__c eventRecord;

        private Builder(){
            eventRecord = new Event__c();
        }

        public Builder save(){
            upsert eventRecord;
            return this;
        }

        public Builder setName(String Name){
            eventRecord.Name = Name;
            return this;
        }

		public Builder setStartDatetime(Datetime startDatetime){
            eventRecord.Start_datetime__c = startDatetime;
            return this;
        }

		public Builder setFinishDatetime(Datetime finishDatetime){
            eventRecord.Finish_datetime__c = finishDatetime;
            return this;
        }

		public Builder setTopic(String topic){
            eventRecord.Topic__c = topic;
            return this;
        }

		public Builder setTeacher(Id teacher){
            eventRecord.Teacher__c = teacher;
            return this;
        }

		public Builder setType(String type){
            eventRecord.Type__c = type;
            return this;
        }

        public Event__c getRecord(){
            return eventRecord;
        }

    }
}