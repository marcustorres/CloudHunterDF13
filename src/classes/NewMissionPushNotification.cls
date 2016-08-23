public class NewMissionPushNotification {

    @future(callout=true)
    public static void sendNewMissionNotification(Set<Id> newMissionIds){
        if (Push_Notification_Setting__c.getOrgDefaults().Enable_Push_Notifications__c) {
            List<Mission__c> missions = [select id, Name, game__c from Mission__c where id in :newMissionIds]; 
            
            Set<Id> gameIds = new Set<Id>();
            for (Mission__c m : missions){
                gameIds.add(m.game__c);
            }
            
            //Query to see if the game(s) is still active and if it has any active players
            //to send notifications to
            List<Player__c> activePlayers = [select id from Player__c 
                                             where game__c in :gameIds 
                                             and game__r.End_date_time__c > :datetime.now()];
            
            if (activePlayers.size() == 0)
                return;
                                   
            UAPushNotificationSvc svc = new UAPushNotificationSvc('Cloud Hunter');
            for (Mission__c m : missions)
            {
                UAPushNotification notification = new UAPushNotification(null , null, null,
                                                                         'A new mission has been added',
                                                                          null);
                try
                {
                    //svc.sendAndroidBroadcastNotification(notification);
                    svc.sendiOSBroadcastNotification(notification);
                }
                catch(UAException e)
                {
                    System.debug('Could not send Urban Airship notification');
                }   
            }                
        }
	}
}