/*
----------------------------------------------------------------------
-- - Name          : VeilleBeforeInsert
-- - Author        : Paul BENARD - Bluetis
-- - Description   : Classe de l'objet Information_du_compte__c
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 02-NOV-2016   PBE    1.0      Initial version
-- 20-JUL-2018   NDI    2.0      Ouverture de droits
----------------------------------------------------------------------
*/
public without sharing class AP11InfoDuCompte {
    public static void CanAddInfo(List<Information_du_compte__c> listInfo){
        Set<Id> compteExistantIds = new Set<Id>();
        for(Information_du_compte__c infoDuCompte : listInfo){
            compteExistantIds.add(infoDuCompte.Compte__c);
        }
        List<Information_du_compte__c> result = [SELECT Id, Compte__c FROM Information_du_compte__c WHERE Compte__c IN :compteExistantIds];
        if(result.size()>0){
            Set<Id> compteIds = new Set<Id>();
            for(Information_du_compte__c infoExistante : result){
                compteIds.add(infoExistante.Compte__c);
            }
            for(Information_du_compte__c infoDuCompte : listInfo){
                if(compteIds.contains(infoDuCompte.Compte__c)){
                    infoDuCompte.addError(Label.ErrorInfoDuCompte);
                }
            }
        } 
    }

    public static void createOperationShare(List<Information_du_compte__c> listInfo){
        System.debug('## AP11InfoDuCompte.createOperationShare START');
/*NDI20180720
        Set<Id> accountIds = new Set<Id>();
        List<Information_du_compte__Share> listInfoShare = new List<Information_du_compte__Share>();
        for(Information_du_compte__c info : listInfo){
            accountIds.add(info.Compte__c);
        }
        if(accountIds.size()>0){
            List<Membre_du_compte__c> listMembreDuCompte = DAL.getMembreDuCompteByAccountIds(accountIds);
            for(Information_du_compte__c info : listInfo){
                for(Membre_du_compte__c membreDuCompte : listMembreDuCompte){
                    if(membreDuCompte.Compte__c == info.Compte__c && membreDuCompte.Utilisateur__c != UserInfo.getUserId()){
                        Information_du_compte__Share idcs = new Information_du_compte__Share();
                        idcs.UserOrGroupId = membreDuCompte.Utilisateur__c;
                        idcs.ParentId = info.Id;
                        idcs.AccessLevel = membreDuCompte.Acces_a_operation__c == 'Lecteur' ? 'Read' : 'Edit';
                        listInfoShare.add(idcs);
                    }
                }
            }
        }
        if(listInfoShare.size()>0){
            insert listInfoShare;
        }
 */
         System.debug('## AP11InfoDuCompte.createOperationShare END');
    }

}