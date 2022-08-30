public with sharing class AccountHouseholdQueue implements Queueable, Database.AllowsCallouts {
    List <Account> AccountsToUpdate= new List<Account>();
    
    public AccountHouseholdQueue(Set<Id> setIds) {
        AccountsToUpdate = [ SELECT Name FROM Account WHERE Id IN :setIds ];
    }
    public void execute(QueueableContext context){
        //async update of account
        for(Account acc: AccountsToUpdate) {
            acc.Name += ' Household';
        }
        update AccountsToUpdate;
    }
}
