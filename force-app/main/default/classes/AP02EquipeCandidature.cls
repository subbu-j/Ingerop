/*
----------------------------------------------------------------------
-- - Name          : AP02EquipeCandidature
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Methods for SObject Equipe_Candidature__c
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 17-JUN-2016   BTH    1.0      Initial version
-- 19-OCT-2016	 PBE	1.1		 AssignDateDeRemise
-- 09-JUL-2017 	 NDI 	2.0 	 Statut Candidature Perdue en Non Retenue
----------------------------------------------------------------------
*/
public with sharing class AP02EquipeCandidature {
 
    public static void createIngeropCoTraitant(List<Equipe_Candidature__c> listEC){
        System.debug('## AP02EquipeCandidature.createIngeropCoTraitant START');
        List<Equipe_Candidature__c> listEquipeCandidature = DAL.getEquipeCandidatureBySetIds((new Map<Id, SObject>(listEC).keySet()));
        List<Membre_d_Equipe_Candidature__c> listIngeropCoTraitant = new List<Membre_d_Equipe_Candidature__c>();
        Account accountIngerop = DAL.getAccountbyName('INGEROP');
        for(Equipe_Candidature__c ec : listEquipeCandidature){
            if(accountIngerop != null){
                listIngeropCoTraitant.add(new Membre_d_Equipe_Candidature__c(Equipe_Candidature__c = ec.Id, type__c = 'Co-Traitant', Accord__c = 'Oui', Mandataire__c = true, Compte__c = accountIngerop.Id));
                ec.Mandataire__c = accountIngerop.Id;
            }
        }
        if(listIngeropCoTraitant.size()>0){
            insert listIngeropCoTraitant;
            update listEquipeCandidature;
        }
        System.debug('## AP02EquipeCandidature.createIngeropCoTraitant END');
    }

    public static void emptyMandataireOnEquipe(set<Id> setIdEquipeCandidatureToUpdate) {
        System.debug('## AP02EquipeCandidature.emptyMandataireOnEquipe START');
        if(!setIdEquipeCandidatureToUpdate.isEmpty()){
            list<Equipe_Candidature__c> listEquipe = DAL.getEquipeCandidatureBySetIds(setIdEquipeCandidatureToUpdate);

            for(Equipe_Candidature__c ec : listEquipe){
                ec.Mandataire__c = null;
            }
            update listEquipe;
        }
        System.debug('## AP02EquipeCandidature.emptyMandataireOnEquipe END');
    }

    public static void addMandataireOnEquipe(Set<Id> candidatureIds, Map<Id, Id> mapMandataire){
        System.debug('## AP02EquipeCandidature.addMandataireOnEquipe START');
        List<Equipe_Candidature__c> listEquipeCandidatureToUpdate = new List<Equipe_Candidature__c>();
        for(Id candidatureId : candidatureIds){
            listEquipeCandidatureToUpdate.add(new Equipe_Candidature__c(Id = candidatureId, Mandataire__c = mapMandataire.get(candidatureId))); 
        }
        update listEquipeCandidatureToUpdate;
        System.debug('## AP02EquipeCandidature.addMandataireOnEquipe END');
    }
    
    public static void majOperation(list<Equipe_Candidature__c> listCandidatureOld, list<Equipe_Candidature__c> listCandidatureNew){
        System.debug('####Start of method AP02EquipeCandidature.MajOperation');
        map<id, Equipe_Candidature__c> mapCandidature = new Map<id,Equipe_Candidature__c>();
        set<id>IdOperation = new Set<id>();
        list<Operation__c> listOperation = new list<Operation__c>();
        for(integer i = 0; i < listCandidatureNew.size(); i++){
            if(listCandidatureNew[i].statut__c != listCandidatureOld[i].statut__c){
                //Si le nouveau statut est perdue ou Abandonnée par le client ou Abandonnée par Ingérop
                //if(listCandidatureNew[i].statut__c == label.statut_Perdue || listCandidatureNew[i].statut__c == label.Statut_abandonneeParLeClient || listCandidatureNew[i].statut__c == label.Statut_abandonneeParIngerop){
                // NDI 20170708 : Perdue en nonRetenue
                if(listCandidatureNew[i].statut__c == label.statut_nonRetenue || listCandidatureNew[i].statut__c == label.Statut_abandonneeParLeClient || listCandidatureNew[i].statut__c == label.Statut_abandonneeParIngerop){
                    //On associe l'opération à la candidature Mise à jour
                    mapCandidature.put(listCandidatureNew[i].Operation__c, listCandidatureNew[i]);
                    idOperation.add(listCandidatureNew[i].Operation__c);
                }
                //NDI ajouté car nouveau statut aussi RETENUE
                if(listCandidatureNew[i].statut__c == label.statut_Retenue){
                	System.debug('####AP02EquipeCandidature.MajOperation : nouveau Statut candidature : Retenue');  
                    mapCandidature.put(listCandidatureNew[i].Operation__c, listCandidatureNew[i]);
                    idOperation.add(listCandidatureNew[i].Operation__c);
                }

            }
        }
        //On récupère les opérations qui ont comme phase Commerciale Candidature
        listOperation = DAL.getOperationAndCandidatureByPhaseCommercialeAndId(IdOperation, label.PhaseCommerciale_Candidature);
        system.debug('listOperation :' + listOperation);
        update GetOperationToUpdate(listOperation,mapCandidature);      
		System.debug('####End of method AP02EquipeCandidature.MajOperation');
    }
    
    //Retourne les opérations à mettre à jour
     public static list<Operation__c> GetOperationToUpdate(list<Operation__c> listOperation, map<id, Equipe_Candidature__c> mapCandidature){
        System.debug('####Start of method AP02Candidature.GetOperationToUpdate');
        list<Operation__c> listOperationToUpdate = new list<operation__c>();
        for(Operation__c op : listOperation){
            //Si le statut est le même sur chaque candidature
            if(CheckIfCandidatureSameStatut(op,mapCandidature)){
              //on change le statut de l'opportunité
                if (mapCandidature.get(op.id).statut__c==label.statut_nonRetenue){
                    op.statut__c = label.statut_Perdue;
                    System.debug('####AP02Candidature.GetOperationToUpdate : statut PERDUE');
                }else if(mapCandidature.get(op.id).statut__c==label.statut_Retenue){
                    op.statut__c = label.statut_Gagnee;
                    System.debug('####AP02Candidature.GetOperationToUpdate : statut GAGNEE');
                }else{
                    op.statut__c = mapCandidature.get(op.id).statut__c;
                    System.debug('####AP02Candidature.GetOperationToUpdate : statut ' + mapCandidature.get(op.id).statut__c);
                }
                  
              listOperationToUpdate.add(op);  
            }
        }
         System.debug('####End of method AP02Candidature.GetOperationToUpdate');
         return listOperationToUpdate;
    }
    
    //Vérifie que l'opération a toutes ses candidatures au même statut
    public static Boolean CheckIfCandidatureSameStatut(Operation__c operation, map<id, Equipe_Candidature__c> mapCandidature){
        System.debug('####Start of method AP02Candidature.CheckIfCandidatureSameStatut');
        for(Equipe_Candidature__c cand : operation.Candidatures__r){
            if(cand.statut__c != mapCandidature.get(operation.id).statut__c) return false;
        }
        return true;
    }
    
    //Récupère la date prévisionnelle de candidature de l'opération si il n'y
    //a pas de candidature sur l'opération sinon prend la date de remise maximum des 
    //candidatures présentes sur l'opération
    public static void AssignDateDeRemise(List<Equipe_Candidature__c> listCandidature){
        System.debug('####Start of method AP02Candidature.AssignDateDeRemise');
        map<id, Equipe_Candidature__c> mapCand = new Map<id,Equipe_Candidature__c>();
        for(Equipe_Candidature__c e :listCandidature){
            mapCand.put(e.Operation__c,e);
        }
        List<Operation__c> listOperation = DAL.getOperationByIds(mapCand.keySet());
        for(Equipe_Candidature__c candTriggered : listCandidature){
        	for(Operation__c ope : listOperation){
        		if(candTriggered.Operation__c == ope.Id){
        			if(ope.TECH_MAX_DateLimiteDeRemise__c !=null){
        				candTriggered.Date_limite_de_remise__c = ope.TECH_MAX_DateLimiteDeRemise__c;
        			}
        			else{
        				candTriggered.Date_limite_de_remise__c = ope.Date_previsionnelle_de_candidature__c; 
        			}
        		}
        	}
        }
        System.debug('####End of method AP02Candidature.AssignDateDeRemise');
	}
}