public class PlayerDeactivateExt {
	
    public Boolean success { get; private set; }
	Player__c player { get; set; }
    public PlayerDeactivateExt(ApexPages.StandardController con) {
        player = (Player__c)con.getRecord();
        success = false;
    }
    
    public void deactivate() {
    	User u = new User(Id = player.user__c, isActive = false);
        Database.SaveResult r = Database.update(u, false);
        success = r.isSuccess();
        if(success) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Success: User Deactivated')); }
        else { 
            for(Database.error e:r.getErrors()) {
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStatusCode() + ':' + e.getMessage())); 
            }
        }
    }
}