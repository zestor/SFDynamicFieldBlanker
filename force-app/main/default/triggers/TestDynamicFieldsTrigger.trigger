trigger TestDynamicFieldsTrigger on TestDynamicFields__c (before update) 
{
    String selectedObject = 'TestDynamicFields__c';

    if (Trigger.isBefore && Trigger.isUpdate) {

        Map<String, BlankField__mdt> FieldMappings = new Map<String, BlankField__mdt>(); 
        for(BlankField__mdt objBF : [SELECT FieldValues__c, BlankFields__c FROM BlankField__mdt])
        FieldMappings.put(objBF.FieldValues__c, objBF);

        for(TestDynamicFields__c obj : Trigger.new) {
            for (String mapKey : FieldMappings.keySet()) {
                System.debug('TestDynamicFieldsTrigger|mapKey=' + mapKey);
                List<String> fieldsToCheck = BlankFieldsTriggerHelper.getFieldsToCheck(mapKey);

                String changedFieldsPattern = BlankFieldsTriggerHelper.getFieldsValues(selectedObject, fieldsToCheck, obj, Trigger.oldMap.get(obj.Id));

                System.debug('TestDynamicFieldsTrigger|changedFieldsPattern=' + changedFieldsPattern);

                if(FieldMappings.containsKey(changedFieldsPattern)) {
                    BlankField__mdt bf = FieldMappings.get(changedFieldsPattern);
                    String mapBlankFields = bf.BlankFields__c;
                    String[] fieldsToBlank = mapBlankFields.split(',');
                    for(String fieldName : fieldsToBlank) {
                        System.debug('TestDynamicFieldsTrigger|blankfield='+fieldName);
                        obj.put(fieldName,null);
                    }
                    break;
                }
            }
        }
    }
}

