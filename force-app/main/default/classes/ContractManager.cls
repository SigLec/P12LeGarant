@RestResource(urlMapping='/Contract/*')
global with sharing class ContractManager {
  @HttpPost
    global static String createNewContract(Id accountId, String status, Date startDate, Integer contractTerm) {
        Contract thisContract = new Contract(
        AccountId=accountId,
        Status=status,
        StartDate=startDate,
        ContractTerm=contractTerm);
        insert thisContract;
        return 'Le contrat n° ' + thisContract.ID + ' a bien été créé';
      }
    
    @httpPatch
    global static String updateContractFields(Id accountId, String status, Date startDate, Integer contractTerm) {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contract contract = [SELECT Id FROM Contract WHERE Id = :contractId];
        Contract thisContract = new Contract(
        Id=contractId,
        AccountId=accountId,
        Status=status,
        StartDate=startDate,
        ContractTerm=contractTerm);
        update thisContract;
        return 'Le contrat n° ' + thisContract.Id + ' a bien été mis à jour';
    }
}
