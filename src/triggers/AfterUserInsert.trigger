trigger AfterUserInsert on User (after insert) {
    List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
    Id psId = IDP_Connection_Settings__c.getOrgDefaults().Permission_Set_ID__c;
    if (psId != null && !''.equals(psId) ) {
        for(User a:Trigger.new) {
            if (a.username.contains(Cloud_Hunter_Settings__c.getOrgDefaults().Username_Suffix__c) ) {
                PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = psId, AssigneeId = a.id);
                psaList.add(psa);                
            }
        }
        if (psaList.size() > 0) {
            insert psaList;
        }
    }
}