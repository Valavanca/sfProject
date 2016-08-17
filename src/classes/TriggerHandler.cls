public abstract class TriggerHandler{

	protected Map<Id, SObject> OldMap {get; set;} 
	protected Map<Id, SObject> NewMap {get; set;} 
	protected List<SObject> OldList {get; set;} 
	protected List<SObject> NewList {get; set;} 

	public TriggerHandler(Map<Id, SObject> old_map, Map<Id, SObject> new_map, List<SObject> old_list, List<SObject> new_list) { 
		this.OldMap = old_map; 
		this.NewMap = new_map; 
		this.OldList = old_list; 
		this.NewList = new_list; 
	}
	
 
}