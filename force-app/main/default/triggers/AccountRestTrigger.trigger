trigger AccountRestTrigger on Account (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        System.enqueueJob(new AccountHouseholdQueue(Trigger.newMap.keySet()));
    }
}