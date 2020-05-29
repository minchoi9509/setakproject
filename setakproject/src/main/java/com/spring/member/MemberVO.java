package com.spring.member;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter 
public class MemberVO {
	String member_name;
	String member_id;
	String member_password;
	String pw2;
	String member_phone;
	String member_email;
	String member_zipcode;
	String member_loc;
	Date member_join;
    Integer subs_num;
    String member_memo;
}
