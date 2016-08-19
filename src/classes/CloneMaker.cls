public abstract class CloneMaker { 
	public List<SObject> createSObjectList (Integer quantity, SObject exemplarSObject){
			List<SObject> SObjectList = new List<SObject>();
			for (Integer i = 0; i < quantity; i++){
				SObjectList.add(exemplarSObject.clone(false,true,true,true)); 
			}
			return SObjectList;
		}

		public List<SObject> createSObjectList (Integer quantity, SObject exemplarSObjectFirst, SObject exemplarSObjectSecond){
			List<SObject> SObjectList = new List<SObject>();
			for (Integer i = 0; i < quantity; i++){
				if(Math.mod(i,2) == 0){
				SObjectList.add(exemplarSObjectFirst.clone(false,true,true,true)); 
				} else{
				SObjectList.add(exemplarSObjectSecond.clone(false,true,true,true)); 
				}
			}
			return SObjectList;
		}
}