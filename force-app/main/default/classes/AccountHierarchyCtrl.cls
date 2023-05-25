public class AccountHierarchyCtrl {
    public Boolean isSF1 { get; set; }
    
    public AccountHierarchyCtrl(ApexPages.StandardController controller) {
        isSF1 = (ApexPages.currentPage().getParameters().get('isdtp') == 'p1');    
    }
}