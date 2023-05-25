public with sharing class VFC05NewCandidature {
    public id OperationId {get;set;}
    public static id idMember{get; set;}
    public VFC05NewCandidature(apexPages.StandardController controller){
        OperationId = ApexPages.currentPage().getParameters().get('OperationId');
        
            
    }
    @RemoteAction
    public static id createCandidature(id OperationId){
        system.debug('#####id = ' + OperationId);
        Equipe_Candidature__c newMember = new Equipe_Candidature__c(Operation__c = OperationId);
        insert newMember;
        idMember = newMember.id;
        return idMember;
   }
}