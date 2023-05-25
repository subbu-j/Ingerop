/*
----------------------------------------------------------------------
-- - Name          : AP10Compte_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for class : AP10Compte
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
private class AP10Compte_TEST {
    static List<Account> listAccount;

    static{
        listAccount = new List<Account>{
            new Account(Name = 'Compte 1', Activite__c = Label.Batiment, Prive_public__c = 'Public'),
            new Account(Name = 'Compte 2', Activite__c = Label.Energie_Industrie, Prive_public__c = 'Public')
        };
        insert listAccount;
    }

    static testmethod void testModifyActivity(){
        listAccount[0].Activite__c = Label.Batiment+';'+Label.Eau_Environnement+';'+Label.Energie_Industrie+';'+Label.Ville_Mobilite;
        update listAccount[0];
        Account accountAfterUpdate = DAL.getAccountById(listAccount[0].Id);
        System.assert(accountAfterUpdate.TECH_Activit_Batiment__c);
        System.assert(accountAfterUpdate.TECH_Activite_Eau_Environnement__c);
        System.assert(accountAfterUpdate.TECH_Activite_Energie_Industrie__c);
        System.assert(accountAfterUpdate.TECH_Activite_Ville_Mobilite__c);
    }
}