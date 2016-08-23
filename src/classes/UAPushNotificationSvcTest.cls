@IsTest
public class UAPushNotificationSvcTest {
    private static string testSettingName = 'UAPushNotificationSvcTest';
    
    private static void createPushSettings(){
        Push_Notification_Setting__c s = new Push_Notification_Setting__c(Name = testSettingName,
                                                                        Key__c = 'abc',
                                                                        Master_Secret__c = 'xyz');
        Database.insert(s);
    }
    
    private static void setupTestCallout(Integer statusCode){
        MyHttp h = MyHttp.getInstance(); 
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        List<HttpResponse> a = new List<HttpResponse>();
        a.add(res);
        h.setMockResponseList(a);
    }

    static testmethod void testiOSPushNotification() {
        createPushSettings();
        UAPushNotificationSvc svc = new UAPushNotificationSvc(testSettingName);        
        UAPushNotification pushAlert = new UAPushNotification(new String[]{'123'},
                                                              new String[]{'123'},
                                                              new String[]{'123'},
                                                              'Test Alert',        
                                                              new Map<String, String>{'1' => '123'});
        setupTestCallout(200);
        Test.startTest();
        svc.sendiOSPushNotification(pushAlert);
        Test.stopTest();
    }

    static testmethod void testiOSPushNotificationNegative() {
        createPushSettings();
        UAPushNotificationSvc svc = new UAPushNotificationSvc(testSettingName);        
        UAPushNotification pushAlert = new UAPushNotification(new String[]{'123'},
                                                              new String[]{'123'},
                                                              new String[]{'123'},
                                                              'Test Alert',        
                                                              new Map<String, String>{'1' => '123'});
        setupTestCallout(400);
        Test.startTest();
        try{
            svc.sendiOSPushNotification(pushAlert);
        }catch(UAException u){}
        Test.stopTest();
    }

    static testmethod void testAndroidPushNotification() {
        createPushSettings();
        UAPushNotificationSvc svc = new UAPushNotificationSvc(testSettingName);        
        UAPushNotification pushAlert = new UAPushNotification(new String[]{'123'},
                                                              new String[]{'123'},
                                                              new String[]{'123'},
                                                              'Test Alert',
                                                              new Map<String, String>{'1' => '123'});
        setupTestCallout(200);
        Test.startTest();
        svc.sendAndroidPushNotification(pushAlert);
        Test.stopTest();
    }

    static testmethod void testiOSBroadcastNotification() {
        createPushSettings();
        UAPushNotificationSvc svc = new UAPushNotificationSvc(testSettingName);        
        UAPushNotification pushAlert = new UAPushNotification(null,
                                                              null,
                                                              null,
                                                              'Test Broadcast Alert',
                                                              new Map<String, String>{'1' => '123'});
        setupTestCallout(200);
        Test.startTest();
        svc.sendiOSBroadcastNotification(pushAlert);
        Test.stopTest();
    }

    static testmethod void testAndroidBroadcastNotification() {
        createPushSettings();
        UAPushNotificationSvc svc = new UAPushNotificationSvc(testSettingName);        
        UAPushNotification pushAlert = new UAPushNotification(null,
                                                              null,
                                                              null,
                                                              'Test Broadcast Alert',
                                                              new Map<String, String>{'1' => '123'});
        Test.startTest();
        setupTestCallout(200);
        svc.sendAndroidBroadcastNotification(pushAlert);
        Test.stopTest();
    }
}