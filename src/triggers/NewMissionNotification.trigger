trigger NewMissionNotification on Mission__c (after insert) {
    NewMissionPushNotification.sendNewMissionNotification(Trigger.newMap.keySet());
}