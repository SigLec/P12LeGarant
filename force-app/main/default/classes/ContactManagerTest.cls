@isTest
private class ContactManagerTest {
  // Helper method
    static Id createTestRecord() {
        Contact contactTest = new Contact(
        LastName='LastNameTest',
        FirstName='FirstNameTest',
        Email='emailtest@gmail.com');
        insert contactTest;
        return contactTest.Id;
      }
    
    @isTest
    static void testCreateNewContact() {
        // Call the method to test
        String testContact = ContactManager.createNewContact(
        'lastname1', 'firstname1', 'email1@gmail.com');
        // Query to find the contact fields in Salesforce
        Contact thisContact = [SELECT Id, Email FROM Contact WHERE Email =: 'email1@gmail.com'];
        // Verify results
        System.assert(thisContact != null);
        System.assert(thisContact.Id != null);
        System.assertEquals(thisContact.Email, 'email1@gmail.com');
        System.assert(testContact.contains('Le nouveau contact '));
    }
    
    @isTest
    static void testCreateNewContactAlreadyInSalesforce() {
        Id recordId = createTestRecord();
        // Call the method to test
        String testDuplicateContact = ContactManager.createNewContact(
        'lastname2', 'firstname2', 'emailtest@gmail.com');
        // Verify results
        Contact thisContact = [SELECT Id, Email FROM Contact WHERE Email=:'emailtest@gmail.com'];
        System.assertEquals(thisContact.Id, recordId);
        System.assert(testDuplicateContact.contains('Ce contact est déjà présent '));

    }
    
  @isTest
    static void testUpdateContactFields() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://legarant9-dev-ed.my.salesforce.com/services/apexrest/Contact/' + recordId;
        request.httpMethod='PATCH';
        request.addHeader('Content-type', 'application/json');
        // Blob valueOf = convert binary data from string
        request.requestBody = Blob.valueOf('{"LastName":"UpatedLastNameTest"}');
        RestContext.request = request;
        // Update LastName of existing record to working
        String thisTestContact = ContactManager.updateContactFields();
        // Verify record was updated
        Contact thisContact = [SELECT Id, LastName FROM Contact WHERE Id =:recordId];
        System.assert(thisContact!=null);
        System.assertEquals(thisContact.LastName, 'UpatedLastNameTest');
        System.assert(thisTestContact.contains(' a bien été mis à jour'));
      }
    
    @isTest
    static void testDesactiveContact() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestURI='https://legarant9-dev-ed.my.salesforce.com/services/apexrest/Contact/' + recordId;
        request.httpMethod='DELETE';
        RestContext.request=request;
        List<Contact> contactsBeforeDelete = [SELECT Id FROM Contact WHERE Active__c=false];
    System.assertEquals(0, contactsBeforeDelete.size());
        // Call the method to test
        ContactManager.desactiveContact();
        // Verify contact is desactivated
        List<Contact> contactsAfterDelete = [SELECT Id FROM Contact WHERE Active__c=false];
      Contact contactAfterDelete = contactsAfterDelete.get(0);
        System.assertEquals(1, contactsAfterDelete.size());
        System.assertEquals(contactAfterDelete.Id, recordId);
    }    
}
