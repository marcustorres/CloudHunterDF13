/* Methods for calling out to a remote salesforce organization
   to read and write data. Primarily Chatter related but not exclusively. 
   Also contains functions using callouts that are required because of Chatter
   SObject API deficiencies. */
public class RemoteUtils {
    
    /* */
    public static Id copyRemoteProfilePhoto(Id userId, String provider, String token, String socialAlias) {
        
        /* Get the profile photo from the remote organization. */
        if (provider != null && token != null) {            
            Blob photo = getPhotoFromURL(provider, token, socialAlias);
            String photoBody = EncodingUtil.base64Encode(photo);
            System.debug('Photo Body:'+photoBody);
            /* Create the file (content) record in the local org with the blob from the 
remote org. */
            if (photoBody != 'Tm8gSW1hZ2U=') {
                System.debug('Image found. Creating a file record');
                return createFileRecord(userId, photo);
            } else {
                System.debug('Could not retrieve an image from the URL.  Returning null');
                return null;   
            }
        } else {
            return null;
        }
    }
    
    /* Creates the chatter profile photo from the body of the specified document record Id
       for the given userId. */
    @future(callout=true)
    public static void createProfilePhoto(String token, Id fileId, String sid, String host) {
        
        IDP_Connection_Settings__c userSettings = new IDP_Connection_Settings__c(SetupOwnerId = UserInfo.getUserId());
        userSettings.Access_Token__c = token;
        
        HttpRequest req = new HttpRequest();
        String u = host + '/services/data/v25.0/chatter/users/me/photo?fileId=' + fileId;
        req.setEndpoint(u);

        req.setHeader('Authorization', 'OAuth ' + sid);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setMethod('POST');
        
        MyHttp h = MyHttp.getInstance();
        HttpResponse res = h.send(req);
        system.debug('HttpResonse.Status: ' + res.getStatus());
        system.debug('HttpResonse.StatusCode: ' + res.getStatusCode()); 
        system.debug('HttpResonse.Body: ' + res.getBody());    
        System.debug('CREATEPROFILEPHOTO RESPONSE: ' + res.getBody());
        
        /* Now mark the user as initialized. */
        if(res.getStatusCode() == 201) {
            userSettings.Initialized__c = true;
            userSettings.Photo_Id__c = fileId;
        }
        Database.upsertResult r = Database.upsert(userSettings);
        System.debug('USER SETTING UPSERT RESULT: ' + r);
    }
    
    /* Callout to the url to get the photo blobs. 
       TODO: Make this private when done testing. */
    public static Blob getPhotoFromURL(String provider, String token, String socialAlias) {
        
        MyHttp h = MyHttp.getInstance();
        HttpRequest req = new HttpRequest();
        String url;
        
        if (provider == 'Facebook' ) {
            url = 'https://graph.facebook.com/me/picture?type=large&access_token=';
  		    req.setEndpoint(url + token);
        } else if ( provider == 'Twitter' ) {
            String twitterAlias = socialAlias.substringAfter(':');
            System.debug('Twitter Alias: ' + twitterAlias);
            url = 'https://api.twitter.com/1/users/profile_image?screen_name=' + twitterAlias + '&size=bigger';
            req.setEndpoint(url);
        } else {
            return null;
        }

        req.setMethod('GET');
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 302) {
        	String redirectUrl = res.getHeader('Location');
            System.debug('redirectUrl: ' + redirectUrl);
            req.setEndpoint(redirectUrl);
            res = h.send(req);
        } else if (res.getStatusCode() >= 400 ) {
            System.debug('GETPHOTOFROMURL RESPONSE: ' + res.getBody());
        	String noImage = 'No Image';
            Blob noImageBlob = Blob.valueof(noImage);
            return noImageBlob;
        }
        return res.getBodyAsBlob();
    }
    
    /* Creates a file record in the content schema as a holding spot 
       until a callout can be used to write the file to the user's 
       profile photo in a secondary step. The return ID is a ContentDocument
       record ID and NOT a ContentVersion.*/
    public static Id createFileRecord(Id userId, Blob file) { 
        ContentVersion v = new ContentVersion(FirstPublishLocationId = userId, 
                                              PathOnClient='/'+userId+'.jpeg', 
                                              Title = userId, 
                                              VersionData = file);
        Database.insert(v);
        return [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :v.id].ContentDocumentId;
    }
    
}