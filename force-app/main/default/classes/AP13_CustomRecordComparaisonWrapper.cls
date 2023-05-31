/**
 * @description       : The CustomRecordComparaisonWrapper class represents a wrapper for comparing two custom records of the same Salesforce object type.
						It provides functionality to build a wrapper containing the fields to be compared and update the primary record with selected values.
 * @author            : emmanuel.javay@springfive.com
 * @group             : 
 * @last modified on  : 2023-05-25
 * @last modified by  : emmanuel.javay@springfive.com
**/

public class AP13_CustomRecordComparaisonWrapper {

    @AuraEnabled
    public List<CustomRecordComparaisonRow> lstCustomRecordComparaisonRow;
    @AuraEnabled
    public String sObjectAPIName;
    @AuraEnabled
    public Id primarySObjectId;
    
    private sObject primarySObject;
    private sObject secondarySObject;
    private List<String> lstFieldToCompareAPIName;
    private static final String BLANK_OR_NULL_DELIMITER = Label.AURA_CustomRecorCompModal_BlankOrEmptyDelimiter;
    
    
    /**
     * Constructs a AP13_CustomRecordComparaisonWrapper object with the primary and secondary records and the fields to compare.
     * @param primarySObject The primary record to compare.
     * @param secondarySObject The secondary record to compare.
     * @param lstFieldToCompareAPIName The list of field API names to compare.
    */
    public AP13_CustomRecordComparaisonWrapper(sObject primarySObject, sObject secondarySObject, List<String> lstFieldToCompareAPIName){
        this.primarySObjectId = primarySObject.Id;
        this.primarySObject = primarySObject;
        this.secondarySObject = secondarySObject;
        this.lstFieldToCompareAPIName = lstFieldToCompareAPIName;
    }
    
    /**
     * Builds the wrapper by populating the fields to compare and their details.
     * @throws AP13_CustomRecordComparaisonWrapper If the soObject given in the Constructors are different
	*/
    public void buildWrapper(){
        String primaryObjectAPIName = primarySObject.getSObjectType().getDescribe().getName();
        sObjectAPIName = primaryObjectAPIName;
        String secondaryObjectAPIName = secondarySObject.getSObjectType().getDescribe().getName();
        
        //Check that the two SObject are of the same type
        if(primaryObjectAPIName != secondaryObjectAPIName){
            String exMessage = Label.AP_CustRecCompWrapper_Ex_sObjectDifferent.replace('{{primaryObjectAPIName}}',primaryObjectAPIName).replace('{{secondaryObjectAPIName}}', secondaryObjectAPIName);
            Throw new CustomRecordComparaisonWrapperException(exMessage);
        }
        
        //For each field to display, build a wrapper row to be displayed front side
        SObjectType sObjectType = Schema.getGlobalDescribe().get(primaryObjectAPIName);
		Map<String,Schema.SObjectField> sObjectFields = sObjectType.getDescribe().fields.getMap();
        CustomRecordComparaisonRow crcr;
        CustomRecordComparaisonColumn crcc;
        lstCustomRecordComparaisonRow = new List<CustomRecordComparaisonRow>();
        String tmpValue;
        for(String fieldAPIName: lstFieldToCompareAPIName){
            if(sObjectFields.get(fieldAPIName) != null){
                crcr = new CustomRecordComparaisonRow();
                crcr.columns = new List<CustomRecordComparaisonColumn>();
                
                crcr.fieldLabel = sObjectFields.get(fieldAPIName).getDescribe().getLabel();
                crcr.fieldAPIName = sObjectFields.get(fieldAPIName).getDescribe().getName();
                crcr.fieldType = String.valueOf(sObjectFields.get(fieldAPIName).getDescribe().getType());
                crcr.selectedValue = String.valueOf(BLANK_OR_NULL_DELIMITER);
                
                crcc = new CustomRecordComparaisonColumn();
                tmpValue = String.valueOf(primarySObject.get(fieldAPIName));
                crcc.value = String.isBlank(tmpValue) ? BLANK_OR_NULL_DELIMITER : tmpValue;
                crcr.columns.add(crcc);
                
                crcc = new CustomRecordComparaisonColumn();
                tmpValue = String.valueOf(secondarySObject.get(fieldAPIName));
                crcc.value = String.isBlank(tmpValue) ? BLANK_OR_NULL_DELIMITER : tmpValue;
                crcr.columns.add(crcc);
                    
                lstCustomRecordComparaisonRow.add(crcr);
            }
        }
    }
    
    /**
     * Gets the updated primary record with the selected values from the wrapper.
     * @return The updated primary record.
	*/
    public sObject getUpdatedPrimarySObject(){
        sObject sObjectInstance = AP12_ApexUtil.getInstanceOfSObjectByAPIName(sObjectAPIName);
        
        sObjectInstance.put('Id', primarySObjectId);
        
        for(CustomRecordComparaisonRow crcr: lstCustomRecordComparaisonRow){
            crcr.selectedValue = String.valueOf(crcr.selectedValue) == BLANK_OR_NULL_DELIMITER ? null : crcr.selectedValue;
            AP12_ApexUtil.castValueForField(sObjectInstance, crcr.fieldType, crcr.fieldAPIName, crcr.selectedValue);
        }
        
        return sObjectInstance;
    }
    
    public class CustomRecordComparaisonRow{
        @AuraEnabled
        public String fieldLabel;
        @AuraEnabled
        public String fieldAPIName;
        @AuraEnabled
        public String fieldType;
        @AuraEnabled
        public String selectedValue;
        @AuraEnabled
        public List<CustomRecordComparaisonColumn> columns;
    }
    public class CustomRecordComparaisonColumn{
        @AuraEnabled
        public String value;
    }
    
    public class CustomRecordComparaisonWrapperException extends Exception{}
}