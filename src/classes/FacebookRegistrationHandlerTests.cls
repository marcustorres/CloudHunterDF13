@IsTest
private class FacebookRegistrationHandlerTests {

    static testMethod void testCreateAndUpdateUser() {
        FacebookRegistrationHandler handler = new FacebookRegistrationHandler();
        Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
            'testFirst testLast', 'testuser@example.org', null, 'testuserlong', 'en_US', 'facebook',
            null, new Map<String, String>{});
            
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Cloud_Hunter_Settings__c c = new Cloud_Hunter_Settings__c(SetupOwnerId = UserInfo.getOrganizationId(), Username_Suffix__c = '@cloudhunter.test');
            Database.insert(c);
        }
        User u = handler.createUser(null, sampleData);
        System.assertEquals('testuserlong'+Cloud_Hunter_Settings__c.getOrgDefaults().Username_Suffix__c, u.userName);
        System.assertEquals('testuser@example.org', u.email);
        System.assertEquals('testLast', u.lastName);
        System.assertEquals('testFirst', u.firstName);
        System.assertEquals('testuser', u.alias);
        insert(u);
        String uid = u.id;
        
        sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
            'testNewFirst testNewLast', 'testnewuser@example.org', null, 'testnewuserlong', 'en_US', 'facebook',
            null, new Map<String, String>{});
        handler.updateUser(uid, null, sampleData);
        
        User updatedUser = [SELECT userName, email, firstName, lastName, alias FROM user WHERE id=:uid];
        System.assertEquals('testnewuserlong'+Cloud_Hunter_Settings__c.getOrgDefaults().Username_Suffix__c, updatedUser.userName);
        System.assertEquals('testnewuser@example.org', updatedUser.email);
        System.assertEquals('testNewLast', updatedUser.lastName);
        System.assertEquals('testNewFirst', updatedUser.firstName);
        System.assertEquals('testnewu', updatedUser.alias);
    }
}