/* Callout responses for testging. */
@IsTest
public class MockCalloutResponses {
    
    public User user { get; set; }
    private Id orgId = '00D000000000000AAA';
    private String instanceUrl = 'https://TESTDOMAINNOTREAL.my.salesforce.com';
    private String photoHost   = 'https://TESTDOMAINNOTREAL--c.na1.content.force.com';
    private String localPhotoHost   = 'https://ANOTHERTESTDOMAINNOTREAL--c.na1.content.force.com';
    
    /* Constructor taking the args needed
       to make the callout responses reflect test 
       setup conditions. */
    public MockCalloutResponses(User u) { user = u; }

    public HttpResponse identityUtils_getRemoteAccessTokenResponse() {
        String response = '{ "id": "https://login.salesforce.com/id/' + orgId + '/' + user.id + '",';
        response       += '"issued_at": "1347837180618",';
        response       += '"scope": "id api refresh_token chatter_api",';
        response       += '"instance_url": "' + instanceUrl + '",';
        response       += '"signature": "7xYgHLSIGNATURE=",';
        response       += '"access_token": "' + orgId + '!NOTREALACCESS_TOKEN" }';
        
        HttpResponse res = new HttpResponse();
        res.setBody(response);
        return res;
    }
    
    public HttpResponse remoteUtils_getRemoteUserResponse() {
        String response = '{"address": {';
        response       += '"state": null,';
        response       += '"country": null,';
        response       += '"street": null,';
        response       += '"city": null,';
        response       += '"zip": null,';
        response       += '"formattedAddress": "add "},';
        response       += '"username": "' + user.username + '",';
        response       += '"email": "' + user.email + '",';
        response       += '"groupCount": 9,';
        response       += '"managerId": null,';
        response       += '"aboutMe": null,';
        response       += '"isActive": true,';
        response       += '"chatterActivity": {';
        response       += '"commentCount": 1,';
        response       += '"commentReceivedCount": 0,';
        response       += '"likeReceivedCount": 0,';
        response       += '"postCount": 0},';
        response       += '"chatterInfluence": {';
        response       += '"rank": 9530,';
        response       += '"percentile": "0.0"},';
        response       += '"followersCount": 17,';
        response       += '"followingCounts": {';
        response       += '"total": 15,';
        response       += '"records": 12,';
        response       += '"people": 3},';
        response       += '"managerName": null,';
        response       += '"phoneNumbers": [],';
        response       += '"name": "' + user.name + '",';
        response       += '"title": "' + user.title + '",';
        response       += '"firstName": "' + user.firstname + '",';
        response       += '"lastName": "' + user.lastname +  '",';
        response       += '"companyName": null,';
        response       += '"mySubscription": null,';
        response       += '"photo": {';
        response       += '"largePhotoUrl": "https://dreamevent--c.na1.content.force.com/profilephoto/72930000000R6ON/F",';
        response       += '"photoVersionId": "72930000000R6ONAA0",';
        response       += '"smallPhotoUrl": "https://dreamevent--c.na1.content.force.com/profilephoto/72930000000R6ON/T"},';
        response       += '"isChatterGuest": false,';
        response       += '"id": "00530000004Pi0pAAC",';
        response       += '"url": "/services/data/v25.0/chatter/users/' + user.id + '",';
        response       += '"type": "User"}';
        
        HttpResponse res = new HttpResponse();
        res.setBody(response);
        return res;
    }
    
    public HttpResponse remoteUtils_createProfilePhotoResponse() {
        String response = '{"largePhotoUrl": "' + localPhotoHost + '/profilephoto/729G00000008wMj/F",';
        response       += '"photoVersionId": "729G00000008wMjIAI",';
        response       += '"smallPhotoUrl": "' + localPhotoHost + '/profilephoto/729G00000008wMj/T"}';
        HttpResponse res = new HttpResponse();
        res.setBody(response);
        res.setStatusCode(201);
        return res;
    }
    
    public HttpResponse remoteUtils_getPhotoFromURLResponse() {
        HttpResponse res = new HttpResponse();
        res.setBody('IMAGETOCONVERTTOBLOB');
        return res;
    }
    
    public HttpResponse remoteUtils_postToChatterResponse() {
        HttpResponse res = new HttpResponse();
        res.setBody('{ "SAMPLE" : { "CHILD" : "VALUE", "ANOTHERCHILD" : "ANOTHER VALUE" } }');
        res.setStatusCode(201);
        return res;
    }
}