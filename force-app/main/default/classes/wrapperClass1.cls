public class wrapperClass1 {

    public AccountWrapper Account;
    public class AccountWrapper {
		public String name;	    
		public String company_external_system_id_c;	    
		public String External_last_modified_datetime;	    
		public List<Oppor> Opportunities;
	}
   public class Oppor {
		public String Name;	    
		public Integer Amount;
		public String Stage;	    
		public String LeadSource;	    
		public String external_system_id_c;	    
		public String external_last_modified_datetime_c;	   
	} 

}