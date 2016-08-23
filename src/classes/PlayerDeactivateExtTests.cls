@IsTest
private class PlayerDeactivateExtTests {

    static testmethod void basicPositiveTest() {
        
        /* Initialize the custom Settings. */
        TestUtils.initSettings();
        
        /* Create the game */
        Game__c g = new Game__c(Name = 'TEST_GAME', Status__c = 'Active');
        Database.insert(g);
        
        /* Create the player */
        Player__c p = TestUtils.createTestPlayer(g.id, TestConstants.USER_LICENSE_SALESFORCE);
        
        /* Construct the standard controller to be injected into the extension controller constructor */
        ApexPages.StandardController con = new ApexPages.StandardController(p);
        
        /* Construct the controller extension class */
        PlayerDeactivateExt ext = new PlayerDeactivateExt(con);
        
        /* Switch context to the runtime of the deactivate action. */
        Test.startTest();
            
        /* invoke the deactivate action on the extension. */
        System.runAs(new User(Id = UserInfo.getUserId())) {
            ext.deactivate();    
        }
            
        /* Switch back to test context for assertions. */
        Test.stopTest();
        
        User u = [SELECT IsActive FROM User WHERE Id = :p.user__c];
        
        System.assert(!u.isActive, 'User was not deactivated by process of invoking the deactivate action.');
        System.assert(ApexPages.getMessages() != null,'Messages collection was null');
        System.assertEquals(1,ApexPages.getMessages().size(),'Messages collection size was not exactly 1.');
        System.assertEquals(ApexPages.Severity.CONFIRM,ApexPages.getMessages().get(0).getSeverity(), 'Messages did not have the right severity enum');
    }
    
    static testmethod void basicNegativeTest() {
        
        /* Initialize the custom Settings. */
        TestUtils.initSettings();
        
        /* Create the game */
        Game__c g = new Game__c(Name = 'TEST_GAME', Status__c = 'Active');
        Database.insert(g);
        
        /* Create the player */
        Player__c p = TestUtils.createTestPlayer(g.id, TestConstants.USER_LICENSE_SALESFORCE);
        
        Id userId = p.user__c;
        
        /* Set th user__c field value to be null to invoke the error path */
		p.user__c = null;
        
        /* Construct the standard controller to be injected into the extension controller constructor */
        ApexPages.StandardController con = new ApexPages.StandardController(p);
        
        /* Construct the controller extension class */
        PlayerDeactivateExt ext = new PlayerDeactivateExt(con);
        
        /* Switch context to the runtime of the deactivate action. */
        Test.startTest();
            
        /* invoke the deactivate action on the extension. */
        System.runAs(new User(Id = UserInfo.getUserId())) {
            ext.deactivate();    
        }
            
        /* Switch back to test context for assertions. */
        Test.stopTest();
        
        User u = [SELECT IsActive FROM User WHERE Id = :userid];
        
        System.assert(ApexPages.getMessages() != null,'Messages collection was null');
        System.assertEquals(1,ApexPages.getMessages().size(),'Messages collection size was not exactly 1.');
        System.assertEquals(ApexPages.Severity.ERROR,ApexPages.getMessages().get(0).getSeverity(), 'Messages did not have the right severity enum');
    }
}