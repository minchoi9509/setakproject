package com.spring.member;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class MemberSubVO {

   private String member_id;
   private int washcnt;
   private int shirtscnt;
   private int drycnt;
   private int blacketcnt;
   private int deliverycnt;
   private String subs_start;
   private String subs_end;
   private String subsname;
   private int subsprice;
   private String subs_cancel;
   private String subs_bye;
   private String customer_uid; 
}
