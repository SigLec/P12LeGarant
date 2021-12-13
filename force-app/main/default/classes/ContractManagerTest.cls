@isTest
private class ContractManagerTest {
    
    // Helper method
    static Id createTestRecord() {
        // Create account before contract to be related to each other
        Account accountTest = new Account(Name='AccountTest');
        insert accountTest;
        Contract contractTest = new Contract(
        AccountId=accountTest.Id,
        Status='Draft',
        StartDate=Date.valueOf('2021-11-30'),
        ContractTerm=4);
        insert contractTest;
        return contractTest.Id;
      }
    
    @isTest
    static void testCreateNewContract() {
        Account accountTestForContract = new Account(Name='accountTestForContract');
        insert accountTestForContract;
        Account resultId = [SELECT Id FROM Account WHERE Name='accountTestForContract'];
        Id accountTestForContractId = resultId.Id;
        ContractManager.createNewContract(accountTestForContract.Id, 'Draft', Date.valueOf('2021-11-30'), 4);
        Contract thisContract = [SELECT Id, AccountId, Status, StartDate, ContractTerm FROM Contract WHERE AccountId =:accountTestForContractId];
        System.assertEquals('Draft', thisContract.Status);
        System.assertEquals(Date.valueOf('2021-11-30'), thisContract.StartDate);
        System.assertEquals(4, thisContract.ContractTerm);
        System.assertEquals(4, thisContract.ContractTerm);
    }
    
    @isTest
    static void testUpdateContractFields() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://legarant9-dev-ed.my.salesforce.com/services/apexrest/Contract/' + recordId;
        request.httpMethod='PATCH';
        request.addHeader('Content-type', 'application/json');
        // Blob valueOf = convert binary data from string
        request.requestBody = Blob.valueOf('{"ContractTerm":"7"}');
        RestContext.request = request;
        // Query to retrieve fields of created contract
        Contract createdContract = [SELECT AccountId, Status, StartDate, ContractTerm FROM Contract WHERE Id =:recordId];
        // Check that contract term is 4 months before updating fields
        System.assertEquals(4, createdContract.ContractTerm);
        // Update contract term value on this created contract
        String contractToUpdate = ContractManager.updateContractFields(createdContract.AccountId, createdContract.Status, createdContract.StartDate, 7);
        Contract updatedContract = [SELECT Id, ContractTerm FROM Contract WHERE Id=:recordId];
        // Verify record was updated
        System.assertEquals(7, updatedContract.ContractTerm);
    }

}

