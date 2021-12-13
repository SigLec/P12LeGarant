@RestResource(urlMapping='/Account/*')
global with sharing class AccountManager {
    
    @HttpPost
    global static String createNewAccount(String name) {
        Account thisAccount = new Account(Name= name);
        insert thisAccount;
        return 'Le compte ' + thisAccount.Id + ' a bien été créé';
    }
    
    @HttpPatch
    global static String updateAccountFields() {
        RestRequest request = Restcontext.request;
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account thisAccount = [SELECT Id FROM Account WHERE Id =: accountId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Account sObject
            thisAccount.put(fieldName, params.get(fieldName));
          }
            update thisAccount;
          return 'Le compte ' + thisAccount.ID + ' a bien été mis à jour';
    }
     
}
