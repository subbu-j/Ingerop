/*
----------------------------------------------------------------------
-- - Name          : VFC10VeilleLue_TEST
-- - Author        : Bluetis
-- - Description   : Test methods for VFC10VeilleLue
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 01-12-2016   BLU    1.0      Initial version
----------------------------------------------------------------------
*/
@isTest
private with sharing class VFC10VeilleLue_TEST {
    static User utilisateur;
    static List<Annonce__c> listVeille;

    static{
        utilisateur = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test'); 
        insert utilisateur;

        System.runAs(utilisateur){
            listVeille = new List<Annonce__c>{
              new Annonce__c(Objet__c = 'Test Objet', Contenu__c = 'Contenu test')
            };
            insert listVeille;
        }
    }

    static testmethod void testRecuperer(){
        System.runAs(utilisateur){
            ApexPages.StandardController standardController = new ApexPages.StandardController(listVeille[0]);
            VFC10VeilleLue controller = new VFC10VeilleLue(standardController);
            VFC10VeilleLue.recuperation(listVeille[0].Id);
            Annonce__c veille = DAL.getVeilleById(listVeille[0].Id);
            System.assertEquals(utilisateur.Id, veille.OwnerId);
        }   
    }
}