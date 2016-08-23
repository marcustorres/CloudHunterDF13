/* Tests for the integrationimpl class. */
@IsTest
public class IntegrationImplTests {
    
    /* The down the middle initialization use case when user is not initialized. */
    static testmethod void basicInitializeUserTest() {
        /* Create the test permset */
        //PermissionSet ps = SAMLControllerTests.createPermissionSet('Salesforce Platform');
        User runningUser = new User(Id = UserInfo.getUserId());
        System.runAs(runningUser) {
            /* Initialize org settings. */
            TestUtils.initSettings();
        }
        
        /* Create the local user. */
        User u = TestUtils.createTestUserObject('Salesforce Platform');
        
        /* Set the callout responses. 
           The initialize method performs the following callouts:
                1) IdentityUtils.getRemoteAccessToken() 
                2) RemoteUtils.getRemoteUser();
                3) RemoteUtils.getPhotoFromURL()
                4) RemoteUtils.createProfilePhoto()*

            *this is annotated @future. 
        */
        MockCalloutResponses mock = new MockCalloutResponses(u);
        List<HttpResponse> responses = new List<HttpResponse>();
        
        //System.assert(false,'REMOTEACCESSTOKEN RESPONSE: ' + mock..getBody());
        responses.add(mock.remoteUtils_getPhotoFromURLResponse());
        responses.add(mock.remoteUtils_createProfilePhotoResponse());
        
        /* Get the http instance */
        MyHttp h = MyHttp.getInstance();
        h.setMockResponseList(responses);
        Id fileId;
        
        /* Switch context to the new user and initialize. */
        System.runAs(u) {
            /* Set the test context here to force future methods to run synchronously. */
            Test.startTest();
            IntegrationImpl i = new IntegrationImpl();
            fileId = i.initializeUser();
            Test.stopTest();
        }
        
        /* Assertions:
                1) Custom setting inidicates initialized
                2) custom setting has a contentDocument ID 
                3) User title was updated. */
        IDP_Connection_Settings__c userSetting = IDP_Connection_Settings__c.getValues(u.id);
        System.assert(userSetting.initialized__c, 'Initialized__c value on user level setting was not true as expected.');
        System.assertEquals(fileId,userSetting.Photo_Id__c, 'Photo ID Value on the user level setting did not match the file id created in the initializeUSer method. ');
        System.assertEquals(u.title, [SELECT Title FROM User WHERE Id = :u.id].title, 'Title on user was not updated. ');
        
    }
    
    /* Use case where the method is called and the user is initialized. Should be a no-op.*/
    static testmethod void userAlreadyInitializedTest() {
        /* Create the test permset */
        User runningUser = new User(Id = UserInfo.getUserId());
        System.runAs(runningUser) {
            /* Initialize org settings. */
            TestUtils.initSettings();
        }
        
        /* Create the local user. */
        User u = TestUtils.createTestUserObject('Salesforce Platform');
        
        Id fileId;
        System.runAs(u) {
            /* Create a file */
            fileId = RemoteUtils.createFileRecord(u.id,Blob.valueOf('IMAGE'));
        }
        
        System.runAs(runningUser) {
            /* Initialize the user settings:
                -.Refresh_Token__c
            */
            IDP_Connection_Settings__c s = new IDP_Connection_Settings__c(SetupOwnerId = u.id, Access_Token__c = 'SOMEREFRESHTOKENVALUE', Initialized__c = true, Photo_Id__c = fileId);
            Database.insert(s);
        }
        
        Id returnId;
        /* Switch context to the new user and initialize. */
        System.runAs(u) {
            /* Set the test context here to force future methods to run synchronously. */
            Test.startTest();
            IntegrationImpl i = new IntegrationImpl();
            returnId = i.initializeUser();
            Test.stopTest();
        }
         
        System.assert(returnId == null, 'The fileId returned from initializeUser should have been null');                                                
    }
    
    static testmethod void postToChatterTest() {
        /* Create the local user. */
        User u = TestUtils.createTestUserObject('Salesforce Platform');
        User runningUser = new User(Id = UserInfo.getUserId());
        
        System.runAs(runningUser) {
            /* Initialize the user settings:
                -.Refresh_Token__c
            */
            IDP_Connection_Settings__c s = new IDP_Connection_Settings__c(SetupOwnerId = u.id, Access_Token__c = 'SOMEREFRESHTOKENVALUE');
            Database.insert(s);
        }
        
        MockCalloutResponses mock = new MockCalloutResponses(u);
        List<HttpResponse> responses = new List<HttpResponse>();
        responses.add(mock.identityUtils_getRemoteAccessTokenResponse());
        responses.add(mock.remoteUtils_postToChatterResponse());
        
        /* Get the http instance */
        MyHttp h = MyHttp.getInstance();
        h.setMockResponseList(responses);
        
        System.runAs(u) {
            /* Set the test context here to force future methods to run synchronously. */
            Test.startTest();
            IntegrationImpl i = new IntegrationImpl();
            i.postToSocialFeed('POST TEXT', u.id, null, null);
            Test.stopTest();
        }
    }
}