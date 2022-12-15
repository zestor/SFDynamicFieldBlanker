trigger TestDynamicFieldsTrigger on TestDynamicFields__c (before update) 
{
    String selectedObject = 'TestDynamicFields__c';

    if (Trigger.isBefore && Trigger.isUpdate) {

        // IMPORTANT: the field names must be in lowercase alphabetical order
        // Since Summer 2015 release, iteration order for Maps and Sets has been predictable
        // Elements are returned in the same order they were added
        Map<String,String> FieldMappings = new Map<String,String>();
        FieldMappings.put('picklist1__c=Value1,picklist2__c=Value1,','show2__c,show4__c');
        FieldMappings.put('picklist1__c=Value2,picklist2__c=Value2,','show1__c,show3__c');
        FieldMappings.put('picklist3__c=Guardians of the Galaxy,','show1__c,show2__c,show3__c,show4__c,show5__c');

        for(TestDynamicFields__c obj : Trigger.new) {
            for (String mapKey : FieldMappings.keySet()) {

                // From the map, check field values for a match
                // Example 'picklist1__c=Value1,picklist2__c=Value1' becomes List with values of picklist1__c and picklist2__c
                List<String> fieldsToCheck = BlankFieldsTriggerHelper.getFieldsToCheck(mapKey);

                // check the current object and return the same fields as above with their values
                // List with values of picklist1__c and picklist2__c 
                // may return 'picklist1__c=Value1,piclist2__c=Value1,'
                String changedFieldsPattern = BlankFieldsTriggerHelper.getFieldsValues(selectedObject, fieldsToCheck, obj, Trigger.oldMap.get(obj.Id));

                System.debug('TestDynamicFieldsTrigger|changedFieldsPattern=' + changedFieldsPattern);

                // now a match becomes very easy and fast by retrieving the current object
                // relavant fields and values from in the same pattern as Map key
                if(FieldMappings.containsKey(changedFieldsPattern)) {

                    // if we have a match, we need to blank out some fields, which is the value retrieve by the key
                    String mapBlankFields = FieldMappings.get(changedFieldsPattern);

                    // we split the string into fields and loop through them setting the value to null
                    String[] fieldsToBlank = mapBlankFields.split(',');
                    for(String fieldName : fieldsToBlank) {
                        obj.put(fieldName,null);
                    }
                    break;
                }
            }
        }
    }
}

