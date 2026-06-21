public class Handler {
 
    public static void method1(List<Movie_Booking__c>booking){
        List<Id>showss=new List<Id>();
        List<String>seatss=new List<String>();
        for(Movie_Booking__c m:booking){
            showss.add(m.Show__c);
            seatss.add(m.Seat_Type__c);
        }
        List<Movie_Booking__c>listData=[Select Id , Seat_Count__c, Seat_Type__c , Show__c , CreatedDate from Movie_Booking__c where Show__c IN :showss and Seat_Type__c IN :seatss ];
        Map<Id,Movie_Booking__c>map1=new Map<Id,Movie_Booking__c>();
        Map<Id,String>map2=new Map<Id,String>();
        Map<Id,DateTime>map3=new Map<Id,DateTime>();
        for(Movie_Booking__c m1:listData){
            map1.put(m1.Show__c,m1);
            map2.put(m1.Show__c,m1.Seat_Type__c);
            map3.put(m1.Show__c,m1.CreatedDate);
        }
        List<Movie_Booking__c>DeleteRec=new List<Movie_Booking__c>();
     //   List<Movie_Booking__c>updateRec=new List<Movie_Booking__c>();
        for(Movie_Booking__c m:booking){
            if(map2.containsKey(m.show__c)){
                if(map2.get(m.Show__c)==m.Seat_Type__c && map3.get(m.Show__c).date()==Date.today()){
                    DeleteRec.add(map1.get(m.Show__c));
                    Movie_Booking__c m22=map1.get(m.Show__c);
                    m.Seat_Count__c+=m22.Seat_Count__c;
                }
            }
            m.Status__c='Pending';
        }
        
        List<Movie_Booking__c>delerec=[Select Id from Movie_Booking__c where ID IN :DeleteRec];
        System.debug('Delete Records are'+delerec);
        delete delerec;
        
    }
    
    
    public static void method2(List<Movie_Booking__c>bookings){
        List<Id>showss=new List<Id>();
        for(Movie_Booking__c m:bookings){
            showss.add(m.Show__c);
        }
        List<Show__c>showData=[Select ID , HouseFULL__c, Available_Seats__c  from Show__c where ID IN :showss];
        List<Show__c>showsNaya=new List<Show__c>();
        Map<Id,Decimal>map2=new Map<Id,Decimal>();
        Map<Id,Decimal>newMap=new Map<Id,Decimal>();
        Map<Id,Decimal>newMap1=new Map<Id,Decimal>();
        for(Show__c s: showData){
            map2.put(s.Id,s.Available_Seats__c);
        }
        for(Movie_Booking__c m1: bookings){
            if(map2.get(m1.Show__c)-m1.Seat_Count__c<0){
                m1.addError('This number of seats are not available');
            }
            else if(map2.get(m1.Show__c)-m1.Seat_Count__c==0){
               newMap.put(m1.Show__c,map2.get(m1.Show__c)-m1.Seat_Count__c);                
            }
            else{
               newMap1.put(m1.Show__c,map2.get(m1.Show__c)-m1.Seat_Count__c); 
            }
        }
        
        List<Show__c>show1=[Select ID , HouseFULL__c, Available_Seats__c  from Show__c where ID IN :newMap.KeySet()];
        List<Show__c>show2=[Select ID , HouseFULL__c, Available_Seats__c  from Show__c where ID IN :newMap1.KeySet()];
        
        for(Show__c s: show1){
            s.Available_Seats__c=newMap.get(s.Id);
            s.HouseFULL__c=true;
        }
        for(Show__c s: show2){
            s.Available_Seats__c=newMap1.get(s.Id);
        }
        update show1;
        update show2;
    }
    
    public static void method3(List<Movie_Booking__c>movies,Set<Id>couponCode){
        List<Coupon1__c>coupons=[Select ID , isActive__c, Start_Date__c, End_Date__c,Type__c,DiscountAmt__c, Name FROM Coupon1__c where Id IN :couponCode];
        Map<Id,Coupon1__c>mpp=new Map<Id,Coupon1__c>();
        for(Coupon1__c c:coupons){
            mpp.put(c.Id,c);
        }
        for(Movie_Booking__c m:movies){
            Coupon1__c c1=mpp.get(m.Coupon__c);
            if(c1.isActive__c==false){
                m.addError('Coupon is Inactive');
            }
            else if(c1.Start_Date__c>m.CreatedDate || c1.End_Date__c<m.CreatedDate){
                m.addError('Coupon is Invalid');
            }
            else {
                if(c1.Type__c=='Flat'){
                  m.Total_Amount__c=m.SubTotal__c-c1.DiscountAmt__c; 
                }
                else if(c1.Type__c=='Discount'){
                   m.Total_Amount__c=m.SubTotal__c-(m.SubTotal__c*c1.DiscountAmt__c)/100;
                }
                
            }
        }
        
    }
}