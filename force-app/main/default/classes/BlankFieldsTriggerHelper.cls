public class BlankFieldsTriggerHelper {

    // Given a mapping, 
    // extract the fields which have defined values
    public static List<String> getFieldsToCheck(String fieldsAndValues) {
        List<String> retval = new List<String>();
        String[] vals = fieldsAndValues.split(',');
        for(String val : vals) {
            String[] fieldNameAndValue = val.split('=');
            String fieldName = fieldNameAndValue.get(0);
            System.debug('Class:BlankFieldsTriggerHelper|Method:getFieldsToCheck|field=' + fieldName);
            retval.add(fieldName);
        }
        return retval;
    }

    // Given the current object, 
    // if any fields with a mapping have changed,
    // return those fields with values being saved
    public static String getFieldsValues(String selectedObject, List<String> fieldsToCheck, Sobject new_o, Sobject old_o) {
        String changedFieldsPattern = '';
        for(String fieldName : BlankFieldsTriggerHelper.getFields(selectedObject)) {
            if(fieldsToCheck.contains(fieldName)) {
                object newval = new_o.get(fieldName);
                object oldval = old_o.get(fieldName);
                System.debug('Class:BlankFieldsTriggerHelper|Method:getFieldsValues|fieldName='+fieldName);
                System.debug('Class:BlankFieldsTriggerHelper|Method:getFieldsValues|newval='+newval);
                System.debug('Class:BlankFieldsTriggerHelper|Method:getFieldsValues|oldval='+oldval);
                //if( new_o.get(fieldName) != old_o.get(fieldName))
                //{
                    System.debug('Class:BlankFieldsTriggerHelper|Method:getFieldsValues,fieldmatch');
                    changedFieldsPattern += fieldName + '=' + new_o.get(fieldName) + ',' ;
                //}
            }
        }
        return changedFieldsPattern;
    }

    // Using the Metadata API, 
    // get all the fields for this object
    public static List<String> getFields(String selectedObject) {
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(selectedObject);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
        List<String> retval = new List<String>();
        retval.addAll(MapofField.keySet());
        retval.sort(); // Important: sort fields in asending order for pattern match
        for(String s : retval) {
            System.debug('Class:BlankFieldsTriggerHelper|Method:getFields|fieldName=' + s);
        }
        return retval;
    }
}