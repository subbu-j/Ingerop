/*
----------------------------------------------------------------------
-- - Name          : VFC05NewCandidature_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for VFC05NewCandidature
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-NOV-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
@isTest
private class VFC05NewCandidature_TEST {
    static List<Account> listAccount;
    static List<Operation__c> listOperation;

    static{
        listAccount = new List<Account>{
            new Account(Name = 'Compte 1', Activite__c = Label.Batiment, Prive_public__c = 'Public'),
            new Account(Name = 'INGEROP', Activite__c = Label.Batiment, Prive_public__c = 'Public')
        };
        insert listAccount;

        listOperation = new List<Operation__c>{
            new Operation__c(Name = 'Op test', Compte__c = listAccount[0].Id)
        };
        insert listOperation;
    }

    static testMethod void testInit(){
        PageReference pageRef = Page.VFP05NewCandidature;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('OperationId', listOperation[0].Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(listOperation[0]);
        VFC05NewCandidature controller = new VFC05NewCandidature(standardController);
        System.assertEquals(listOperation[0].Id, controller.OperationId);
    }

    static testMethod void testCreateCandidature(){
        Id idMember = VFC05NewCandidature.createCandidature(listOperation[0].Id);
        System.assertNotEquals(null, idMember);
    }
}