package com.spring.community;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class ReplyVO {
	private int reply_seq; 
	private int qna_num;
	private Date reply_date;
	private String reply_content;
	private String member_id;
	private int reply_group;
	private int reply_order; 
	private int reply_update; 
	private int reply_delete; 
}
