/**
 * @description       : Class Util to be used accross other Apex classes
 * @author            : emmanuel.javay@springfive.com
 * @group             : 
 * @last modified on  : 2023-05-25
 * @last modified by  : emmanuel.javay@springfive.com
**/
public class AP12_ApexUtil {

    /**
     * Casts a value and sets it on a field of an sObject instance. 
     * @param sObjectInstance The sObject instance to set the field value on.
     * @param sfFieldType The Salesforce field type to cast the value to.
     * @param sfFieldAPIName The API name of the field to set the value on.
     * @param value The value to be casted and set on the field.
     * @throws ApexUtilException If the casted type is not supported for the field.
	*/
    public static void castValueForField(sObject sObjectInstance, String sfFieldType, String sfFieldAPIName, Object value){
        
        switch on SfFieldType{
            when 'String', 'STRING', 'URL', 'EMAIL', 'ID', 'TEXTAREA', 'PICKLIST', 'PHONE'{
                sObjectInstance.put(sfFieldAPIName, String.valueOf(value));
            }
            when 'Integer'{
                sObjectInstance.put(sfFieldAPIName, Integer.valueOf(value));
            }
            when 'Decimal', 'CURRENCY', 'PERCENT'{
                sObjectInstance.put(sfFieldAPIName, Decimal.valueOf(String.valueOf(value)));
            }
            when 'Double', 'DOUBLE'{
                sObjectInstance.put(sfFieldAPIName, Double.valueOf(value));
            }
            when 'Date'{
                sObjectInstance.put(sfFieldAPIName, Date.valueOf(String.valueOf(value)));
            }
            when 'DateTime'{
                sObjectInstance.put(sfFieldAPIName, DateTime.valueOf(String.valueOf(value)));
            }
            when else {
                String exMessage = Label.AP_ApexUtil_Ex_CastField.replace('{{SfFieldType}}',SfFieldType).replace('{{sfFieldAPIName}}', sfFieldAPIName);
               	Throw new ApexUtilException(exMessage);
           }
        }
        
    }
    
    /**
     * Retrieves an instance of an sObject based on its API name.
     * @param sObjectAPIName The API name of the sObject.
     * @return An instance of the specified sObject.    
     * @throws ApexUtilException If the provided type doesn't map to an sObject in the org.
	*/
    public static sObject getInstanceOfSObjectByAPIName(String sObjectAPIName){
        
        Map<String, Schema.SObjectType> globDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType sOType = globDescribe.get(sObjectAPIName);     
        if(sOType == null){
            String exMessage = Label.AP_ApexUtil_Ex_sObjectNotFound.replace('{{sObjectAPIName}}', sObjectAPIName);
            Throw new ApexUtilException(exMessage);
        }
        else
            return sOType.newSobject();
        
    }
    
    public class ApexUtilException extends Exception{}
}