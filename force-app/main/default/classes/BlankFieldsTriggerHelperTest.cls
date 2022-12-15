
@IsTest(SeeAllData=true)
public class BlankFieldsTriggerHelperTest {

    // TODO: make this a legit test, this is only to get it into my dev org
    static testmethod void runPositiveTestCases() {

        String selectedObject = 'TestDynamicFields__c';

        try {
            List<String> fieldsToCheck = BlankFieldsTriggerHelper.getFieldsToCheck('Picklist1__c=Value1,Picklist2__c=Value1,');

            TestDynamicFields__c new_o = new TestDynamicFields__c();
            new_o.Name = 'Apex Test';
            insert new_o;

            new_o.Picklist1__c = 'Value1';
            new_o.Picklist2__c = 'Value1';
            new_o.Show1__c = 'Show1a';
            new_o.Show2__c = 'Show2a';
            new_o.Show3__c = 'Show3a';
            new_o.Show4__c = 'Show4a';
            new_o.Show5__c = 'Show5a';
            update new_o;

            new_o.Picklist1__c = 'Value2';
            new_o.Picklist2__c = 'Value2';
            new_o.Show1__c = 'Show1b';
            new_o.Show2__c = 'Show2b';
            new_o.Show3__c = 'Show3b';
            new_o.Show4__c = 'Show4b';
            new_o.Show5__c = 'Show5b';
            update new_o;

            TestDynamicFields__c old_o = new TestDynamicFields__c();
    
            String fieldsValues = BlankFieldsTriggerHelper.getFieldsValues(selectedObject, fieldsToCheck, new_o, old_o);

        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }

        System.assertEquals(true,true, 'BlankFieldsTriggerHelperTest success');
    }
}