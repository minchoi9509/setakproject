package com.spring.member;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class CouponVO {
	
	private String member_id;
	private String coupon_name;
	private String coupon_start;
	private String coupon_end;
	private String coupon_useday;
	private String coupon_use;
	private int coupon_seq; 

}
