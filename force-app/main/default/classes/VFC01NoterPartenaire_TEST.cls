/*
----------------------------------------------------------------------
-- - Name          : VFC01NoterPartenaire_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for VFC01NoterPartenaire
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 13-JUN-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
@isTest
private class VFC01NoterPartenaire_TEST {
    static Id recordTypePartenaire;
    static User utilisateur1;
    static User utilisateur2;
    static List<Account> listAccount;
    static List<Score__c> listNote;

    static{
        recordTypePartenaire = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partenaire').getRecordTypeId();

        utilisateur1 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test Code1'); 
        insert utilisateur1;

        utilisateur2 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test Code2'); 
        insert utilisateur2;

        listAccount = new List<Account>{
            new Account(Name = 'Compte partenaire', RecordTypeId = recordTypePartenaire)
        };
        insert listAccount;

        listNote = new List<Score__c>{
            new Score__c(Compte__c = listAccount[0].Id, Utilisateur__c = utilisateur2.Id, Note_attribuee__c = 5)
        };
        insert listNote;
    }

    static testmethod void testInitDepuisUnCompte(){
        System.runAs(utilisateur1){
            PageReference pageRef = Page.VFP01NoterPartenaire;
            Test.setCurrentPageReference(pageRef);
            ApexPages.CurrentPage().getparameters().put('idAccount', listAccount[0].Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Score__c());
            VFC01NoterPartenaire controller = new VFC01NoterPartenaire(standardController);
            System.assertEquals(listAccount[0].Id, controller.accountId);
            System.assertEquals(0, controller.noteActuelle);
        }   
    }

    static testmethod void testInitDepuisUneNote(){
        System.runAs(utilisateur2){
            PageReference pageRef = Page.VFP01NoterPartenaire;
            Test.setCurrentPageReference(pageRef);
            ApexPages.CurrentPage().getparameters().put('id', listNote[0].Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(listNote[0]);
            VFC01NoterPartenaire controller = new VFC01NoterPartenaire(standardController);
            System.assertEquals(listAccount[0].Id, controller.accountId);
            System.assertEquals(5, controller.noteActuelle);
        }   
    }

    static testmethod void testDonnerUneNote(){
        System.runAs(utilisateur1){
            PageReference pageRef = Page.VFP01NoterPartenaire;
            Test.setCurrentPageReference(pageRef);
            ApexPages.CurrentPage().getparameters().put('idAccount', listAccount[0].Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Score__c());
            VFC01NoterPartenaire controller = new VFC01NoterPartenaire(standardController);
            controller.noteActuelle = 5;
            controller.donnerUneNote();
        }   
        List<Score__c> tempList = DAL.getNoteByAccount(listAccount[0].Id);
        System.assertEquals(listNote.size()+1, tempList.size());
    }

    static testmethod void testInitUpdateUneNote(){
        System.runAs(utilisateur2){
            PageReference pageRef = Page.VFP01NoterPartenaire;
            Test.setCurrentPageReference(pageRef);
            ApexPages.CurrentPage().getparameters().put('id', listNote[0].Id);
            ApexPages.StandardController standardController = new ApexPages.StandardController(listNote[0]);
            VFC01NoterPartenaire controller = new VFC01NoterPartenaire(standardController);
            controller.noteActuelle = 2;
            controller.donnerUneNote();
            Score__c note = DAL.getNoteById(listNote[0].Id);
            System.assertEquals(2, note.Note_attribuee__c);
        }   
    }

    static testMethod void testNoNoteException(){
        try{
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Score__c());
            VFC01NoterPartenaire controller = new VFC01NoterPartenaire(standardController);
            throw new UnexpectedTryException('An exception should have been thrown by the trigger but was not.');
        }catch(Exception e){
            Boolean expectedExceptionThrown = e.getMessage().contains('Une erreur est survenue. Veuillez réessayer.');
            System.assert(expectedExceptionThrown);
        }
    }

    public class UnexpectedTryException extends Exception {}
}