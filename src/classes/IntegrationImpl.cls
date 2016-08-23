public class IntegrationImpl implements IntegrationIface {
    
    /* Utilize */
    public Id initializeUser() {
        /* current user's id */
        Id userId = UserInfo.getUserId();
        
        /* Get the facebook access token */
        User currentUser = [ SELECT access_token__c, token_secret__c, FederationIdentifier, Identity_Provider__c from USER where id = :userId ];
        String token = currentUser.access_token__c;
        //Alias is used by twitter to obtain the profile photo of the user
        String socialAlias = currentUser.FederationIdentifier;
        String idpProvider = currentUser.Identity_Provider__c;
        
        IDP_Connection_Settings__c userSettings = IDP_Connection_Settings__c.getValues(userId);	    
                
        /* copy the photos to the local org. If user not initialized.  */
        if(userSettings == null || !userSettings.Initialized__c ) {
            
            /* Get the photo from the urls in the remote user and copy to a file 
               in the local org. */
            
            Id fileId = RemoteUtils.copyRemoteProfilePhoto(userId, idpProvider, token, socialAlias);
            
            /* Finally callout to put the file on the profile in the local org. This 
               will be processed asynchronously because:
                    1) Prior methods invoked above establish transactions which block callouts
                    2) Chatter photo processing is asynchronous anyway. */
             if (fileId != null) {
            	RemoteUtils.createProfilePhoto(token, fileId, UserInfo.getSessionID(), IDP_Connection_Settings__c.getOrgDefaults().My_Domain__c);
                return fileId;
            }
        }
        return null;
    }

    public void postToSocialFeed(String message, String userId, Blob file, String fileName) {
        /*TODO: Initial implementation will not post to Facebook */
        //if(!Facebook_Connection_Settings__c.getOrgDefaults().Disable_Chatter_Posting__c) {
        //    RemoteUtils.postToChatter(message, userId, file, fileName);   
        //}
    }
}