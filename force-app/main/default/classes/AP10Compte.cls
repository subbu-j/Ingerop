/*
----------------------------------------------------------------------
-- - Name          : AP10Compte
-- - Author        : Paul BENARD - Bluetis
-- - Description   : Methods for SObject Compte
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-OCT-2016   PBE    1.0      Initial version
----------------------------------------------------------------------
*/
public class AP10Compte {
  public static void SetActivityTech(List<Account> listAccountNew,List<Account> listAccountOld){
      if(listAccountOld==null){
          for(Account a : listAccountNew){
            ModifyActivity(a);
          }
      }
      else{
          for(integer i = 0; i < listAccountNew.size(); i++){
            if(listAccountNew[i].Activite__c != listAccountOld[i].Activite__c){
                ModifyActivity(listAccountNew[i]);
            }
          }
      }
  }
    
    public static void ModifyActivity(Account a){
        if(a.Activite__c != null && (a.Activite__c).contains(Label.Batiment)){
            a.TECH_Activit_Batiment__c = true;
        }
        else{
            a.TECH_Activit_Batiment__c = false;
        }
        if(a.Activite__c != null && (a.Activite__c).contains(Label.Eau_Environnement)){
            a.TECH_Activite_Eau_Environnement__c = true;
        }
        else{
            a.TECH_Activite_Eau_Environnement__c = false;
        }
        if(a.Activite__c != null && (a.Activite__c).contains(Label.Energie_Industrie)){
            a.TECH_Activite_Energie_Industrie__c  = true;
        }
        else{
            a.TECH_Activite_Energie_Industrie__c = false;
        }
        if(a.Activite__c != null && (a.Activite__c).contains(Label.Ville_Mobilite)){
            a.TECH_Activite_Ville_Mobilite__c  = true;
        }
        else{
            a.TECH_Activite_Ville_Mobilite__c = false;
        }   
    } 
    
    
}