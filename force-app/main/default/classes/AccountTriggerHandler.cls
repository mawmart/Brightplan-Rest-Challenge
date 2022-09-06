public with sharing class AccountTriggerHandler {
    public AccountTriggerHandler() {
        if(Trigger.isAfter && Trigger.isInsert){
            System.enqueueJob(new AccountHouseholdQueue(Trigger.newMap.keySet()));
        }
    }
}
