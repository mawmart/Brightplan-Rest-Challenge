/**
 * @description Account REST api Class
*/
@RestResource(urlMapping='/Account/*')
global with sharing class AccountRest {
    global class RestAccount{
        global String id;
        global String name;
        global String phone;
        global String billingStreet;
        global String billingCity;
        global String billingState;
        global String billingCountry;
    }
    /**
     * @description GET accounts endpoint
     * @return List of accounts
     */
    @HttpGet
    global static Account getAccount() {
        Account recordAccount;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        try {
            recordAccount = [SELECT Id,   
            Name
            FROM Account WHERE Id =: accountId
            WITH SECURITY_ENFORCED LIMIT 1];
        } catch(System.QueryException qe){
            System.debug(LoggingLevel.WARN, qe.getMessage());
        }
        return recordAccount;
    }
    /**
     * @description POST accounts endpoint
     * @return Create an account
     */
    @HttpPost
    //reestructure to handle with a inner obj for same properties
    global static List<Account> postAccount(List<RestAccount> restAccounts) {
        List<Account> newAccounts = new List<Account>();
        try {
            for(RestAccount restAccount: restAccounts){
                Account newAccount = new Account();
                newAccount.Name = restAccount.name;
                newAccount.Phone = restAccount.phone;
                newAccount.BillingStreet = restAccount.billingStreet;
                newAccount.BillingCity = restAccount.billingCity;
                newAccount.BillingState = restAccount.billingState;
                newAccount.BillingCountry = restAccount.billingCountry;
                newAccounts.add(newAccount);
            }
            System.debug(newAccounts);
            if(Account.sObjectType.getDescribe().isCreateable()){
                insert newAccounts;
                //create trigger to run async job (queueable)
            }
        } catch(System.QueryException qe){
            System.debug(LoggingLevel.WARN, qe.getMessage());
        }
        return newAccounts;
    }
    /**
     * @description POST accounts endpoint
     */
    @HttpPut
    //reestructure to handle with a inner obj for same properties
    global static Account updateAccount(RestAccount restAccount) {
        Account updAccount;
        try {
            updAccount = [SELECT Id,
            Name,
            Phone, 
            BillingStreet,
            BillingCity,
            BillingState,
            BillingCountry
            FROM Account WHERE Id =: restAccount.id
            WITH SECURITY_ENFORCED LIMIT 1];  

            updAccount.Name = restAccount.name;
            updAccount.Phone = restAccount.phone;
            updAccount.BillingStreet = restAccount.billingStreet;
            updAccount.BillingCity = restAccount.billingCity;
            updAccount.BillingState = restAccount.billingState;
            updAccount.BillingCountry = restAccount.billingCountry;
            if(Account.sObjectType.getDescribe().isUpdateable()){
                upsert updAccount;
            }
        } catch(System.QueryException qe){
            System.debug(LoggingLevel.WARN, qe.getMessage());
        }
        return updAccount;
    }
    /**
     * @description POST accounts endpoint
     */
    @HttpDelete
    //reestructure to handle with a inner obj for same properties
    global static void deleteAccount() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account accountToDelete;
        accountToDelete = [SELECT Id,   
            Name
            FROM Account WHERE Id =: accountId
            WITH SECURITY_ENFORCED LIMIT 1];  
        try {
            if(Account.sObjectType.getDescribe().isDeletable()){
                delete accountToDelete;
            }
        } catch(System.QueryException qe){
            System.debug(LoggingLevel.WARN, qe.getMessage());
        }
    }
}
  