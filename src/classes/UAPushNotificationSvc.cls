public class UAPushNotificationSvc {
    public static String baseUrl ='https://go.urbanairship.com/api/';
    public String applicationName;  
    private Push_Notification_Setting__c pushConfig;
    
    public UAPushNotificationSvc(String appName)
    {
        applicationName = appName;
        try{
        	pushConfig = [select Key__c, Master_Secret__c from Push_Notification_Setting__c where Name = :applicationName];
        }catch(Exception e){}
    }
    
    public void sendiOSPushNotification(UAPushNotification notification)
    {
        if (notification == null || notification.uniqueDeviceIds == null || notification.alert == null)
            return;
        System.debug('Output is:'+notification.iOSJSONString()); 
        send('push/', notification.iOSJSONString(), 'POST');     
    }
    
    public void sendiOSBroadcastNotification(UAPushNotification notification)
    {
        if (notification == null || notification.alert == null || notification.uniqueDeviceIds != null )
            return;
        System.debug(notification.iOSJSONString());  
        send('push/broadcast/', notification.iOSJSONString(), 'POST');       
        
    }

    public void sendAndroidPushNotification(UAPushNotification notification)
    {
        if (notification == null || notification.uniqueDeviceIds == null || notification.alert == null )
            return;
        System.debug('Output is:'+notification.androidJSONString()); 
        send('push/', notification.androidJSONString(), 'POST');     
    }
    
    public void sendAndroidBroadcastNotification(UAPushNotification notification)
    {
        if (notification == null || notification.alert == null || notification.uniqueDeviceIds != null )
            return;
        System.debug(notification.androidJSONString());  
        send('push/broadcast/', notification.androidJSONString(), 'POST');               
    }
    
    public HttpRequest createRequest(string path, string body, string method) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(baseUrl + path);
        req.setMethod(method);
        
        if (pushConfig == null) {
            System.debug(LoggingLevel.ERROR, 'No Urban Airship Push Notification Setting found for ' + applicationName);
            return null;
        } else {
            req.setHeader('Authorization', 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(pushConfig.Key__c + ':' + pushConfig.Master_Secret__c)));
        }
        
        if (body != null) {
            req.setHeader('Content-Length', String.valueOf(body.length()));
            req.setHeader('Content-Type', 'application/json');
            req.setBody(body);
        }
        
        return req;
    }   
    
    public HttpResponse send(string path, string body, string method) {
        MyHttp h = MyHttp.getInstance();
        HttpRequest req = createRequest(path, body, method);
        
        if (req == null)
            return null;
    
        System.debug('Sending to ' + req.getEndpoint() + ': ' + req.getBody());
        HttpResponse res = h.send(req);
        System.debug('Response: ' + res.getBody());
        
        if (res.getStatusCode() != 200)
        {
            System.debug('Response status code: ' + res.getStatusCode());
            throw new UAException (res.getBody());
        }

        return res;
    }    
}