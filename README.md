# SFDynamicFieldBlanker
With Salesforce Dynamic Forms, on before update, blanks fields which are not visible.

While salesforce only saves visible fields on create with dynamic forms. When you edit records fields which are not visible may still have prior values.  Fields which are not visible (based on visibility criteria in the record page) are not automatically cleared to null. This example allows for easy configuration of fieldname/value trigger scenarios for which to clear other fields by setting them to null.

This example simply works on field mappings of name value pairs as trigger criteria which will blank out other fields (defined in a comma separated list of fields).

The mappings are stored in a custom metadata type in this example, they can also be stored in a Map directly in Apex for speed.
I found that Map in Apex runs in my example runs ~90 ms on average, the custom metadata type example runs only slightly slower still around 100 ms. 

The code is bulkified to process multiple record updates.
- For each record, it gets the value of the fields defined in the mapping in alphabetical order with their value.
- If the mapping matches the current record (retrieved by map key) then it blanks a list of fields defined in a comma separated string by field name.
- once it finds a match it breaks out of the loop and no further rules are processed for this record.
