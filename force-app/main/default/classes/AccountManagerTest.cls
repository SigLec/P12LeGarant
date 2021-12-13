@isTest
private class AccountManagerTest {
  // Helper method
    static Id createTestRecord() {
        Account accountTest = new Account(Name='testAccountName');
        insert accountTest;
        return accountTest.Id;
      }
  
    @isTest
    static void testCreateNewAccount() {
        // Call the method to test
        String accountTest = AccountManager.createNewAccount('test');
        // Query to find the contact fields in Salesforce
        Account thisAccount = [SELECT Id, Name FROM Account WHERE Name='test'];
        // Verify results
        System.assert(thisAccount!= null);
        System.assert(thisAccount.Id !=null);
        System.assert(accountTest.contains(' a bien été créé'));
    }
    
  @isTest
    static void testUpdateAccountFields() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://legarant9-dev-ed.my.salesforce.com/services/apexrest/Account/' + recordId;
        request.httpMethod='PATCH';
        request.addHeader('Content-type', 'application/json');
        // Blob valueOf = convert binary data from string
        request.requestBody = Blob.valueOf('{"Name":"UpdatedAccountName"}');
        RestContext.request = request;
        // Update Name of existing record to working
        String thisTestAccount = AccountManager.updateAccountFields();
        // Verify record was updated
        Account thisAccount = [SELECT Id, Name FROM Account WHERE Id =:recordId];
        System.assert(thisAccount!=null);
        System.assertEquals(thisAccount.Name, 'UpdatedAccountName');
        System.assert(thisTestAccount.contains(' a bien été mis à jour'));
      }
}