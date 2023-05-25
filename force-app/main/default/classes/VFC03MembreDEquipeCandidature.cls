/*
----------------------------------------------------------------------
-- - Name          : VFC03MembreDEquipeCandidature
-- - Author        : Mélanie TEXEREAU - Bluetis
-- - Description   : class VFC03MembreDEquipeCandidature
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 21-JUN-2016   MTE    1.0      Initial version
-- 07-JUL-2016   MTE    1.1      Add filter Nom du compte, score + column score + contacts
----------------------------------------------------------------------
*/

public with sharing class VFC03MembreDEquipeCandidature {
    public String activite                                  {   get;set;    }
    public String categorie                                 {   get;set;    }
    public String TypeCompte                                {   get;set;    }
    public String privepublic                               {   get;set;    }
    public String zoneGeo                                   {   get;set;    }
    public String codePostal                                {   get;set;    }
    public String ville                                     {   get;set;    }
    public Equipe_Candidature__c myEquipe                   {   get;set;    }
    public List<AccountWrapper> listAccountWrapper          {   get;set;    }
    public String nomCompte                                 {   get;set;    }
    public Decimal scoreCompte                              {   get;set;    }
    public Map<Id, list<SelectOption>> mapContactByAccount  {   get;set;    }
    public List<OptionPicklist> listActivite                {   get;set;    }
    public Map<String, list<String>> mapCategorieByRT       {   get;set;    }
    
    private final Account acc;

    //Pagination
    public Integer counter = 0; 
    public Integer list_size = 25; 
    public Integer total_size;

    public VFC03MembreDEquipeCandidature() {
        System.debug('## VFC03MembreDEquipeCandidature.init START');
        String idEquipe = ApexPages.currentPage().getParameters().get('id');
        myEquipe = DAL.getEquipeCandidatureById(idEquipe);
        listAccountWrapper = new List<AccountWrapper>();
        initActivites();
        initialisationMapRTCategorie();
        System.debug('## VFC03MembreDEquipeCandidature.init END');
    }
    public void initialisationMapRTCategorie(){
        mapCategorieByRT = new map<String, list<String>>();
        mapCategorieByRT.put(label.RTCompteClient, new list<String>());
        mapCategorieByRT.put(label.RTCompteEntreprise, new list<String>());
        mapCategorieByRT.put(label.RTComptePartenaire, label.CategorieComptePartenaire.split('/'));
        mapCategorieByRT.put(label.RTCompteAutre, label.CategorieCompteAutre.split('/'));
    }
    public list<SelectOption> getCategorieOnAccount(){
        System.debug('## VFC03MembreDEquipeCandidature.getCategorieOnAccount START');
        list<SelectOption> listCategorieToComplete = new list<SelectOption>();        
        //Schema.DescribeFieldResult fieldResult = Account.Categorie__c.getDescribe();
        //List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();  
        listCategorieToComplete.add(new SelectOption('', '- Aucun -'));
        if(mapCategorieByRT.get(TypeCompte) != NULL){
             for(String f : mapCategorieByRT.get(TypeCompte))
            {
                listCategorieToComplete.add(new SelectOption(f, f));
            }     
        }
             
        System.debug('## VFC03MembreDEquipeCandidature.getCategorieOnAccount END');
        return listCategorieToComplete;
    }
    
    public list<SelectOption> getRecordTypeOnAccount(){
        System.debug('## VFC03MembreDEquipeCandidature.getRecordTypeOnAccount START');
        list<SelectOption> listRecordTypeToComplete = new list<SelectOption>();
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        listRecordTypeToComplete.add(new SelectOption('', '- Aucun -'));
        for(Schema.RecordTypeInfo f : RT)
        {
            if(f.getName() != 'Principal'){
                listRecordTypeToComplete.add(new SelectOption(f.getName(), f.getName()));
            }
        }       
        System.debug('## VFC03MembreDEquipeCandidature.getRecordTypeOnAccount END');
        return listRecordTypeToComplete;
    }
    

    public list<SelectOption> getPrivepublicOnAccount(){
        System.debug('## VFC03MembreDEquipeCandidature.getPrivepublicOnAccount START');
        list<SelectOption> listPrivepublicToComplete = new list<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Account.Prive_public__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        listPrivepublicToComplete.add(new SelectOption('', '- Aucun -'));
        for(Schema.PicklistEntry f : ple)
        {
            listPrivepublicToComplete.add(new SelectOption(f.getValue(), f.getLabel()));
        }       
        System.debug('## VFC03MembreDEquipeCandidature.getPrivepublicOnAccount END');
        return listPrivepublicToComplete;
    }

    public void initActivites(){
        System.debug('## VFC03MembreDEquipeCandidature.initActivites START');
        listActivite = new List<OptionPicklist>();
        Schema.DescribeFieldResult fieldResult = Account.Activite__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();    
        for(Schema.PicklistEntry f : ple){
            listActivite.add(new OptionPicklist(f));
        }       
        System.debug('## VFC03MembreDEquipeCandidature.initActivites END');
    }

    public list<SelectOption> getTypes(){
        System.debug('## VFC03MembreDEquipeCandidature.getTypes START');
        list<SelectOption> listType = new list<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Membre_d_Equipe_Candidature__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();    
        listType.add(new SelectOption('', '- Aucun -'));
        for(Schema.PicklistEntry f : ple)
        {
            listType.add(new SelectOption(f.getValue(), f.getLabel()));
        }       
        System.debug('## VFC03MembreDEquipeCandidature.getTypes END');
        return listType;
    }

    public List<SelectOption> getScore(){
        System.debug('## VFC03MembreDEquipeCandidature.getScore START');
        list<SelectOption> listScore = new list<SelectOption>();
        listScore.add(new SelectOption('', '- Aucun -'));
        Decimal i=0;
        for(i=0; i<=5; i+0.5){
            listScore.add(new SelectOption(String.valueOf(i),String.valueOf(i)));
            i+=0.5;
        }      
        System.debug('## VFC03MembreDEquipeCandidature.getScore END');
        return listScore;
    }

    public Map<Id, list<SelectOption>> getContactByAccount(list<Account> listAccount){
        System.debug('## VFC03MembreDEquipeCandidature.getContactByAccount START');
        map<Id, list<SelectOption>> mapAccountWithContacts = new map<Id,list<SelectOption>>();

        for(Account acc : listAccount){
            list<SelectOption> listContact = new list<SelectOption>();
            listContact.add(new SelectOption('', '- Aucun -'));
            if(!acc.Contacts.isEmpty()){
                for(Contact contact : acc.Contacts){
                 
                    listContact.add( new SelectOption(contact.Id, contact.Name));
                }
            }
            
            mapAccountWithContacts.put(acc.Id, listContact);
        }
        System.debug('## VFC03MembreDEquipeCandidature.getContactByAccount END');
        return mapAccountWithContacts;
    }

    public void initPaginationAndSearch(){
        System.debug('## VFC03MembreDEquipeCandidature.initPaginationAndSearch START');
        counter = 0; 
        list_size = 25; 
        search();
        System.debug('## VFC03MembreDEquipeCandidature.initPaginationAndSearch END');
    }

    public void search(){
        System.debug('## VFC03MembreDEquipeCandidature.search START');
        listAccountWrapper = new List<AccountWrapper>();
        Id recordTypePartenaire = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partenaire').getRecordTypeId();
        List<Membre_d_Equipe_Candidature__c> listMembreEquipeCandidature = DAL.getMembreEquipeCandidatureByEquipeCandidatureId(myEquipe.Id);
        List<Id> compteIds = new List<Id>();

        for(Membre_d_Equipe_Candidature__c m : listMembreEquipeCandidature){
            compteIds.add(m.Compte__c);
        }      
        system.debug('######Activite = '  +activite);
        String soql = 'SELECT Id, Name, Note_attribuee__c, (SELECT Id,Name,AccountId FROM Contacts) FROM Account WHERE Id != NULL'; 
        if(activite != null && activite != ''){
            soql += ' AND Activite__c INCLUDES(\'' + activite + '\')';
        }
        if(categorie != null && categorie != ''){
            soql += ' AND Categorie__c INCLUDES(\'' + categorie + '\')';
        }
        if(typeCompte != null && typeCompte !=''){
            soql += ' AND RecordType.DeveloperName = \'' + typeCompte + '\'';
        }
        if(privepublic != null && privepublic != ''){
            soql += ' AND Prive_public__c = \'' + privepublic + '\'';
        }
        if(nomCompte != null && nomCompte != ''){
            soql += ' AND Name LIKE \'' + nomCompte.replace('\'', '\\\'') +'%\'';
        }
        if(scoreCompte != null){
            soql += ' AND Moyenne_des_scores__c =' + scoreCompte;
        }
        if(codePostal != null && codePostal != ''){
            soql += ' AND ShippingPostalCode = \''+ codePostal + '\'';
        }
        if(ville != null && ville != ''){
            soql += ' AND ShippingCity = \'' + ville.replace('\'', '\\\'') + '\'';
        }

        total_size = Database.query(soql).size();

        soql += ' ORDER BY Name ASC LIMIT '+ list_size + ' OFFSET '+ counter;

        for(Account acc : Database.query(soql)){
            listAccountWrapper.add(new AccountWrapper(acc));
        }
        mapContactByAccount = getContactByAccount(Database.query(soql));
        System.debug('## VFC03MembreDEquipeCandidature.search END');
    }

    public void ajouter(){
        System.debug('## VFC03MembreDEquipeCandidature.ajouter START');
        List<Membre_d_Equipe_Candidature__c> listMembreEquipeCandidature = new List<Membre_d_Equipe_Candidature__c>();
        for(AccountWrapper a : listAccountWrapper){
            if(a.toInsert){
                Membre_d_Equipe_Candidature__c membre = new Membre_d_Equipe_Candidature__c();
                membre.Compte__c = a.acc.Id;
                membre.Equipe_Candidature__c = myEquipe.Id;
                membre.Role__c = a.role;
                membre.Type__c = a.type;
                membre.Contact__c = a.contact;
                listMembreEquipeCandidature.add(membre);
            }
        }
        if(listMembreEquipeCandidature.size()>0){
            insert listMembreEquipeCandidature;
        }
        System.debug('## VFC03MembreDEquipeCandidature.ajouter END');
    }

    //user clicked beginning
    public PageReference Beginning() { 
        System.debug('## VFC03MembreDEquipeCandidature.Beginning START');
        counter = 0; 
        search();   
        System.debug('## VFC03MembreDEquipeCandidature.Beginning END');
        return null;
    }
    
    //user clicked previous button
    public PageReference Previous() { 
        System.debug('## VFC03MembreDEquipeCandidature.Previous START');
        counter -= list_size;
        search();
        System.debug('## VFC03MembreDEquipeCandidature.Previous END');
        return null;
    }
    
    //user clicked next button
    public PageReference Next() {
        System.debug('## VFC03MembreDEquipeCandidature.Next START');
        counter += list_size;
        search();
        System.debug('## VFC03MembreDEquipeCandidature.Next END');
        return null;
    }
    
    //user clicked end
    public PageReference End() { 
        System.debug('## VFC03MembreDEquipeCandidature.End START');
        integer counterTemp = counter;
        counter = total_size - math.mod(total_size, list_size);
        if(counter<2000){
            search();
        }else{
            counter = counterTemp;
        }
        System.debug('## VFC03MembreDEquipeCandidature.End END');
        return null;
    }
    
    //this will disable the previous and beginning buttons
    public Boolean getDisablePrevious() {      
        if (counter>0) return false; else return true;
    }

    //this will disable the next and end buttons
    public Boolean getDisableNext() { 
        if (counter + list_size < total_size) return false; else return true;
    }

    public Integer getTotal_size() {
        return total_size;
    }

    public Integer getPageNumber() {
        if ( total_size == null || total_size == 0) {return 0;} 
        return counter/list_size + 1;
    }

    public Integer getTotalPages() {
        if (total_size ==null){return 0;}
        if (math.mod(total_size, list_size) > 0) {
          return total_size/list_size + 1;
        }else {
          return (total_size/list_size);
        }
    }

    public class AccountWrapper{
        public Account acc              {   get;set;    }
        public Boolean toInsert         {   get;set;    }
        public String contact           {   get;set;    }
        public String role              {   get;set;    }
        public String type              {   get;set;    }

        public AccountWrapper(Account account){
            acc = account;
            toInsert = false;
        }
    }

    public class OptionPicklist{
        public String value {get;set;}
        public String label {get;set;}

        public OptionPicklist(Schema.PicklistEntry pe){
            this.value = pe.getValue();
            this.label = pe.getLabel();
        }
    }
}