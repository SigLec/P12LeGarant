@RestResource(urlMapping='/Contact/*')
global with sharing class ContactManager {

    @HttpPost
    global static String createNewContact (String lastname, String firstname, String email) {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = :email];
        Contact thisContact = new Contact();
        if(!contacts.isEmpty()) {
            thisContact = contacts.get(0);
            return 'Ce contact est déjà présent dans Salesforce avec l\'id: ' + thisContact.ID;
        } else {
            thisContact = new Contact(LastName=lastname, FirstName=firstname, Email=email);
            insert thisContact;
            return 'Le nouveau contact ' + thisContact.ID + ' a bien été créé';
        }
    }
    
    @httpPatch
    global static String updateContactFields() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Contact sObject
            thisContact.put(fieldName, params.get(fieldName));
        }
        update thisContact;
        return 'Le contact ' + thisContact.ID + ' a bien été mis à jour';
    }
    
    @HttpDelete
    global static String desactiveContact() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        thisContact.Active__c = false;
        thisContact.Id=contactId;
        update thisContact;
        return 'Le contact ' + thisContact.Id + ' a bien été désactivé';
    }
    
}

