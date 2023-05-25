/*
----------------------------------------------------------------------
-- - Name          : AP01Contact
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Methods for SObject Contact
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 17-JUN-2016   BTH    1.0      Initial version
-- 25-AUG-2017   GBE    1.1      Change checkUserRights method to use UserRecordAccess
-- 20-JUL-2018   NDI    2.0      Ouverture de droits
----------------------------------------------------------------------
*/
public with sharing class AP01Contact {
   
    public static Boolean checkUserRights(List<Contact> listContact){
        for(Contact contact : listContact){
            list<UserRecordAccess> listAccountEditAccess = DAL.getEditAccessByUserIdAndObjectId(UserInfo.getUserId(),contact.AccountId);
            if(listAccountEditAccess.size()==0){return False;}
            for (UserRecordAccess access : listAccountEditAccess){
                if (access.HasEditAccess == False){
                    return False;
                }
            }
        }
        return True;
    }

    public static void createContactShareOnAccount(List<Contact> listContact){
/*NDI20180720
        Set<Id> accountIds = new Set<Id>();
        List<ContactShare> listContactShare = new List<ContactShare>();
        for(Contact contact : listContact){
            accountIds.add(contact.AccountId);
        }
        if(accountIds.size()>0){
            List<Membre_du_compte__c> listMembreDuCompte = DAL.getMembreDuCompteByAccountIds(accountIds);
            for(Contact contact : listContact){
                for(Membre_du_compte__c membreDuCompte : listMembreDuCompte){
                    if(membreDuCompte.Compte__c == contact.AccountId && membreDuCompte.Utilisateur__c != UserInfo.getUserId()){
                        ContactShare cs = new ContactShare();
                        cs.UserOrGroupId = membreDuCompte.Utilisateur__c;
                        cs.ContactId = contact.Id;
                        cs.ContactAccessLevel = membreDuCompte.Acces_au_contact__c == 'Lecteur' ? 'Read' : 'Edit';
                        listContactShare.add(cs);
                    }
                }
            }
        }
        if(listContactShare.size()>0){
            insert listContactShare;
        }
*/        
    }
}