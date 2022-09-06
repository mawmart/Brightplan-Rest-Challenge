trigger AccountRestTrigger on Account (after insert) {
    new AccountTriggerHandler();
}