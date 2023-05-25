/*
----------------------------------------------------------------------
-- - Name          : AP03Offre
-- - Author        : Anael CURATOLO - Bluetis
-- - Description   : Methods for SObject Offre__c
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 06-OCT-2016   ACU    1.0      Initial version
-- 07-OCT-2016   PBE    2.0      Factorisation
----------------------------------------------------------------------
*/
public class AP03Offre {
    public static void majOperation(list<Offre__c> listOffreOld, list<Offre__c> listOffreNew){
        System.debug('####Start of method AP03Offre.MajOperation');
        map<id, Offre__c> mapOffre = new Map<id,Offre__c>();
        set<id>IdOperation = new Set<id>();
        list<Operation__c> listOperation = new list<Operation__c>();
        for(integer i = 0; i < listOffreNew.size(); i++){
            if(listOffreNew[i].statut__c != listOffreOld[i].statut__c){
                //Si le nouveau statut est perdue ou Abandonné par le client ou Abandonné par Ingérop
                if(listOffreNew[i].statut__c == label.statut_Perdue || listOffreNew[i].statut__c == label.Statut_abandonneeParLeClient || listOffreNew[i].statut__c == label.Statut_abandonneeParIngerop){
                    //On associe l'opération à l'offre Mise à jour
                    mapOffre.put(listOffreNew[i].Operation__c, listOffreNew[i]);
                    idOperation.add(listOffreNew[i].Operation__c);
                }
            }
        }
        //On récupère les opérations qui ont comme phase Commerciale offre
        listOperation = DAL.getOperationAndOffreByPhaseCommercialeAndId(IdOperation, label.PhaseCommerciale_Offre);
        update GetOperationToUpdate(listOperation,mapOffre);      
        System.debug('####End of method AP03Offre.MajOperation');
    }
    
    //Retourne les opérations à mettre à jour
     public static list<Operation__c> GetOperationToUpdate(list<Operation__c> listOperation, map<id, Offre__c> mapOffre){
        System.debug('####Start of method AP03Offre.GetOperationToUpdate');
        list<Operation__c> listOperationToUpdate = new list<operation__c>();
        for(Operation__c op : listOperation){
            //Si le statut est le même sur chaque offre
            if(CheckIfOffreSameStatut(op,mapOffre)){
              //on change le statut de l'opportunité
              op.statut__c = mapOffre.get(op.id).statut__c;
              listOperationToUpdate.add(op);  
            }
        }
         System.debug('####End of method AP03Offre.GetOperationToUpdate');
         return listOperationToUpdate;
    }
    
    //Vérifie que l'opération a toutes ces offres au même statut
    public static Boolean CheckIfOffreSameStatut(Operation__c operation, map<id, Offre__c> mapOffre){
        System.debug('####Start of method AP03Offre.CheckIfOffreSameStatut');
        for(Offre__c offre : operation.Offres__r){
            if(offre.statut__c != mapOffre.get(operation.id).statut__c) return false;
        }
        return true;
    }

    
}