/**
*CalcBusinessDaysUtility Class 
*easily skip weekends and holidays from your logic 
**/

public class CalcBusinessDaysUtility{
    
    public BusinessHours bHours;
    
    //Constructor to set business hour name     
    public CalcBusinessDaysUtility(){       
        bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];
    }
    
    public Datetime AddDays(Datetime dSartDate, Integer iDays){ 
        //CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        System.debug('bHours123:'+bHours);
        dSartDate = BusinessHours.nextStartDate(bHours.Id, dSartDate);  
        for (Integer i = 0; i < iDays; i++){         
            dSartDate = dSartDate.addDays(1);           
            if (!BusinessHours.isWithin(bHours.Id, dSartDate)){                
                dSartDate = BusinessHours.nextStartDate(bHours.Id, dSartDate);
            }
        }
        return dSartDate;
    }    
    
    public  Datetime SubtractDays(Datetime dStartDate, Integer iDays){  
        //CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        dStartDate = getPreviousWorkingDay(dStartDate);
        for (Integer i = 0; i < iDays; i++){            
            dStartDate = dStartDate.addDays(-1);
            if (!BusinessHours.isWithin(bHours.Id, dStartDate)){           
                dStartDate = getPreviousWorkingDay(dStartDate);
            }
        }
        return dStartDate;
    }
    
    /**
* Recursive function to get previous working day
* If date passed to this function is on a working day, this will return same date otherwise previous working day     
* *********************
* For Example,
* if passed day is Monday, this will return Monday
* else if passed day is Sunday,then this will return Friday
* *********************    
**/
    public Datetime getPreviousWorkingDay(Datetime d){ 
        //CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        //Check if new date is within working days
        if (!BusinessHours.isWithin(bHours.Id, d)){           
            d = d.addDays(-1);
            return getPreviousWorkingDay(d);
        } else{           
            return d;
        }
    }
    
    /**
* Function to get next working day
* If date passed to this function is on a working day, this will return same date otherwise return next working day     
* *********************
* For Example, 
* if passed day is Monday, this will return Monday
* else if passed day is Sunday, then this will return Monday
* *********************
**/
    public Datetime getNextWorkingDay(Datetime d){
       // CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        return BusinessHours.nextStartDate(bHours.Id, d);
    }
    
    //Check if provided date is working day or not    
    public Boolean isWorkingDay(Datetime d){
      //  CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        return BusinessHours.isWithin(bHours.Id, d);
    }
    
    //Get numbe of business days between two dates 
    public Integer getNoOfBusinessDaysBetweenDates(DateTime dStartDate, DateTime dEndDate){
       // CalcBusinessDaysUtility calc = new CalcBusinessDaysUtility();
        Integer count = 0;
        while(dStartDate <= dEndDate){
            if(BusinessHours.isWithin(bHours.Id, dStartDate)){
                count++;
            }
            dStartDate = dStartDate.addDays(1);
        }
        return count;
    }
}