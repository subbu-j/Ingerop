public with sharing class LCCTRL_AnnonceRelatedOperations {
    
    @AuraEnabled
    public static ObjectWrapper fetchData(String infoJSON) {
        ComponentInfo info = (ComponentInfo)JSON.deserialize(infoJSON, ComponentInfo.class);
        
        String parentField = info.parentField;
        Id parentRecordId = info.parentRecordId;
        
        //System.debug('# fetchData / parentField : ' + parentField);
        //System.debug('# fetchData / parentRecordId : ' + parentRecordId);
        
        if (String.isNotEmpty(info.objectType)) {
            String countQuery = getCountQueryString(info);
            String queryObjects = getObjectQueryString(info);
            
            //System.debug('# fetchData / countQuery : ' + countQuery);
        	//System.debug('# fetchData / queryObjects : ' + queryObjects);
            
            return new ObjectWrapper(
                info.recordToDisplay,
                info.pageNumber,
                Database.countQuery(countQuery),
                Database.query(queryObjects)
            );
        } else {
            return new ObjectWrapper();
        }
    }
    
    private static String getCountQueryString(ComponentInfo info) {
        String objectType = String.escapeSingleQuotes(info.objectType);
        String parentField = info.parentField;
        Id parentRecordId = info.parentRecordId;
        
        //System.debug('# getObjectQueryString / objectType : ' + objectType);
        //System.debug('# getCountQueryString / parentField : ' + parentField);
        //System.debug('# getCountQueryString / parentRecordId : ' + parentRecordId);
        
        String countQuery = 'SELECT count() FROM ';
        countQuery += objectType;
        
        if (String.isNotEmpty(parentField) && parentRecordId != null) {
            parentField = String.escapeSingleQuotes(parentField);
            countQuery += ' WHERE ' + parentField + ' = : parentRecordId';
        }
        
        return countQuery;
    }
    
    private static String getObjectQueryString(ComponentInfo info) {
        String objectType = String.escapeSingleQuotes(info.objectType);
        String parentField = info.parentField;
        Id parentRecordId = info.parentRecordId;
        
        System.debug('# getObjectQueryString / objectType : ' + objectType);
        System.debug('# getObjectQueryString / parentField : ' + parentField);
        System.debug('# getObjectQueryString / parentRecordId : ' + parentRecordId);
        
        String queryObjects = 'SELECT Id, Name, link__c, ID_Explore__c, Lien_Explore__c, URL_Explore__c, Operation__c, Operation__r.Name, CreatedDate, Annonce__c, Operation__r.UFO__c, Operation__r.Owner.Name, Operation__r.Compte__c, Operation__r.Compte__r.Name  FROM ';
        queryObjects += objectType;
        
        if (String.isNotEmpty(parentField) && parentRecordId != null) {
            parentField = String.escapeSingleQuotes(parentField);
            queryObjects += ' WHERE ' + parentField +' = : parentRecordId';
        } else {
            queryObjects += ' ORDER BY Name DESC LIMIT ' + info.recordToDisplay
                + ' OFFSET ' + (info.pageNumber - 1) * info.recordToDisplay;
        }
        
        return queryObjects;
    }
    
    @AuraEnabled
    //public static String unlinkOperation (String recordId, String idExplore){
    public static ObjectWrapper unlinkOperation(String infoJSON) {
        
        ComponentInfo info = (ComponentInfo)JSON.deserialize(infoJSON, ComponentInfo.class);
        
        String recordId = info.recordId;
        String idExplore = info.idExplore;
        
        //System.debug('# unlinkOperation / recordId : ' + recordId);
        //System.debug('# unlinkOperation / idExplore : ' + idExplore); 

		List<Operation__c> listOp = new List<Operation__c>();
        set<Id> opIds = new set<Id>();
        
        List<AnnonceOperations__c> lstAnnonceOperation = [SELECT Id, Operation__c, Annonce__c FROM AnnonceOperations__c WHERE Id =: recordId];
        //System.debug('# unlinkOperation / lstAnnonceOperation : ' + lstAnnonceOperation);
        
        for(AnnonceOperations__c ao : lstAnnonceOperation){
            opIds.add(ao.Operation__c);
        }
        
        listOp = [SELECT Id, Name, Compte__c, Compte__r.Name, Departement__c, estDansMonDepartement__c, estDansMonPole__c, 
                                            link__c,estDansMonService__c, estDansMonUFO__c, Nom_du_r_f_rent__c, Nombre_d_offres__c, Owner.FirstName, Owner.LastName  
                                            FROM Operation__c 
                                            WHERE Id IN :opIds];
        
        //System.debug('# unlinkOperation / listOp : ' + listOp.size());
        
        delete lstAnnonceOperation;

        return fetchData(infoJSON);
    }

    @AuraEnabled
    public static ObjectWrapper deleteRecord(String infoJSON) {
        ComponentInfo info = (ComponentInfo)JSON.deserialize(infoJSON, ComponentInfo.class);
        UserRecordAccess recAccess = [
            SELECT
            HasEditAccess,
            HasDeleteAccess,
            RecordId
            FROM UserRecordAccess
            WHERE UserId =: UserInfo.getUserId()
            AND RecordId =: info.recordId
        ];
        
        if (recAccess != null && recAccess.HasDeleteAccess) {
            try {
                sObject sObj = Schema.getGlobalDescribe().get(info.objectType).newSObject();
                sObj.Id = info.recordId;
                delete sObj;
            } catch (DmlException e) {
                throw new AuraHandledException('Error while deleting data.');
            }
        }
        
        return fetchData(infoJSON);
    }
    
    public class ObjectWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer page {get;set;}
        @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public List<sObject> data {get;set;}
        
        ObjectWrapper(Integer pageSize, Integer page, Integer total, List<sObject> data) {
            this.pageSize = pageSize;
            this.page = page;
            this.total = total;
            this.data = data;
        }
        
        ObjectWrapper() {}
    }
    
    public class ComponentInfo {
        Integer pageNumber;
        Integer recordToDisplay;
        String objectType;
        String parentField;
        Id parentRecordId;
        Id recordId;
        String idExplore;
    }
}