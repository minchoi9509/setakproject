package com.spring.member;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class MileageVO {
	private String member_id;
	private String mile_date;
	private int mile_price;
	private String mile_content;
	private int mile_seq;
	
}
