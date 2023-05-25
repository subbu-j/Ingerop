/*
----------------------------------------------------------------------
-- - Name          : AP08Veille_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for AP08Veille
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 27-SEP-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
@isTest
private class AP08Veille_TEST {
    static Annonce__c annonce;
    
    static{
        annonce = new Annonce__c();
        annonce.Objet__c = 'Test Annonce';
        annonce.Contenu__c = 'Contenu de mon annonce';
        
        insert annonce;
        
        Veille__c v = new Veille__c();
        v.Destinataire__c = UserInfo.getUserId();
        v.Annonce__c = annonce.Id;
        
        insert v;
    }
    static testMethod void testNoDuplicate(){
        
        Veille__c v2 = new Veille__c();
        v2.Destinataire__c = UserInfo.getUserId();
        v2.Annonce__c = annonce.Id;
        
        try{
            insert v2;
        } catch(DmlException e){
            String message = e.getMessage();
            System.assert(message.contains('Le destinataire de cette veille existe déjà pour cette annonce'), message);
        }
    }
}