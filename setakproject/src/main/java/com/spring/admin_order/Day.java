package com.spring.admin_order;

import java.text.SimpleDateFormat;
import java.util.Calendar;

public class Day {

	private static Calendar cal = Calendar.getInstance();
	private static SimpleDateFormat sdf = new SimpleDateFormat("yy/MM/dd");
	private static String today = sdf.format(cal.getTime());
	
	public static String[] get5Days() {	
		
		cal = Calendar.getInstance();
		String[] dateArr = new String[5];
		dateArr[0] = today; 
		for(int i = 1; i < 5; i++) {
			cal.add(Calendar.DATE, -1);
			dateArr[i] = sdf.format(cal.getTime());
		}
		
		return dateArr; 
	}
	
	public static String[] getWeekDays() {
		
		String[] weekArr = new String[10]; 
		weekArr[0] = today;
		cal = Calendar.getInstance();
		for(int i = 1; i < 10; i++) {
			if(i%2 == 0) {
				cal.add(Calendar.DATE, -1);
			}else {
				cal.add(Calendar.DATE, -6);
			}
			weekArr[i] = sdf.format(cal.getTime());
		}
		
		return weekArr; 
	}
	
}