public class TestResultBuilder {

    public static Builder getTestResult(){
        return new Builder();
    }

    public class Builder{
        private TestResult__c TestResultRecord;

        private Builder(){
            TestResultRecord = new TestResult__c();
        }

        public Builder save(){
            upsert TestResultRecord;
            return this;
        }

        public Builder setName(String Name){
            TestResultRecord.Name = Name;
            return this;
        }

		public Builder setEmail(String Email){
            TestResultRecord.Email__c = Email;
            return this;
        }

		public Builder setFirstName(String FirstName){
            TestResultRecord.FirstName__c = FirstName;
            return this;
        }

		public Builder setLastName(String LastName){
            TestResultRecord.LastName__c = LastName;
            return this;
        }

		public Builder setPercentage(String Percentage){
            TestResultRecord.Percentage__c = Percentage;
            return this;
        }


        public TestResult__c getRecord(){
            return TestResultRecord;
        }

    }
 }