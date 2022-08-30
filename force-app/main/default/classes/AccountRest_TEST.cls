@IsTest(SeeAllData=false)
public with sharing class AccountRest_TEST {
    
    @testSetup public static void datasetup(){
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '555-888-828';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingCountry = 'US';
        a.BillingState = 'FL';
        upsert a;
    }
    @isTest public static void GetAccountClassMethod(){
        Account acct = [SELECT Id FROM Account LIMIT 1];
        Test.startTest();
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
                req.requestURI = '/services/apexrest/Account/'+acct.Id;  //Request URL
                req.httpMethod = 'GET';//HTTP Request Type
                RestContext.request = req;
                RestContext.response= res;
            Account accRest = AccountRest.getAccount();
        Test.stopTest();
        System.assert(accRest != null, 'account does not exist');
    }
   @isTest
    static void PostAccountClassMethod(){
        Test.startTest();
			List<AccountRest.RestAccount> fakeReqArr = new List<AccountRest.RestAccount>(); 
            AccountRest.RestAccount fakeReq = new AccountRest.RestAccount();
            fakeReq.Name = 'Test Account 2';
            fakeReq.Phone = '555-888-829';
            fakeReq.BillingStreet = 'Test Street 2';
            fakeReq.BillingCity = 'Test City 2';
            fakeReq.BillingCountry = 'US';
            fakeReq.BillingState = 'FL';
			fakeReqArr.add(fakeReq);        
	        String JsonMsg=JSON.serialize(fakeReqArr);	
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
                req.requestURI = '/services/apexrest/Account/';  //Request URL
                req.httpMethod = 'POST';//HTTP Request Type
                req.requestBody = Blob.valueof(JsonMsg);
                RestContext.request = req;
                RestContext.response= res;
				AccountRest.postAccount(fakeReqArr);
	        Test.stopTest();
        Account acct = [SELECT Id, Name FROM Account WHERE Phone = '555-888-829' LIMIT 1];
        System.assert(acct.Name == 'Test Account 2 Household', 'Does not match Name');
        System.assert(acct != null, 'Account was not created');
    }
    @isTest
    static void updateAccountClassMethod(){
		Account fakeReq = [SELECT Id, Name, Phone, BillingStreet, BillingCity, BillingCountry, BillingState FROM Account LIMIT 1];
        AccountRest.RestAccount fakeReqWrap = new AccountRest.RestAccount();
	        fakeReqWrap.Id = fakeReq.Id;
            fakeReqWrap.Name = fakeReq.Name;
            fakeReqWrap.BillingStreet = fakeReq.BillingStreet;
            fakeReqWrap.BillingCity = fakeReq.BillingCity;
            fakeReqWrap.BillingCountry = fakeReq.BillingCountry;
            fakeReqWrap.BillingState = fakeReq.BillingState;
	 		fakeReqWrap.Phone = '555-888-830';
        Test.startTest();
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
                req.requestURI = '/services/apexrest/Account/';  //Request URL
                req.httpMethod = 'PUT';//HTTP Request Type
                RestContext.request = req;
                RestContext.response= res;
            Account accRest = AccountRest.updateAccount(fakeReqWrap);
        Test.stopTest();
        Account acct = [SELECT Id, Phone FROM Account WHERE Name = 'Test Account Household' LIMIT 1];
        System.assert(accRest.Phone == '555-888-830', 'Phone number doesn`t update');
    }
    @isTest
    static void updateBOClassMethod1(){
        Account acct = [SELECT Id FROM Account LIMIT 1];
        Test.startTest();
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
                req.requestURI = '/services/apexrest/Account/'+acct.Id;  //Request URL
                req.httpMethod = 'DELETE';//HTTP Request Type
                RestContext.request = req;
                RestContext.response= res;
            AccountRest.deleteAccount();
        Test.stopTest();
        List<Account> acctDel = [SELECT Id FROM Account WHERE Id =:acct.Id];
        System.assertEquals(acctDel.size(), 0, 'account has not been deleted');
    }
}