package com.spring.community;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class QnaVO 
{
	private int qna_num;
	private String member_id;
	private String qna_type;
	private long order_num;
	private String qna_title;
	private String qna_content;
	private String qna_date;
	private String qna_file;
	private String qna_check;	
	private String qna_scr;
	private String qna_pass;
	
	
	public int getQna_num() {
		return qna_num;
	}
	public void setQna_num(int qna_num) {
		this.qna_num = qna_num;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getQna_type() {
		return qna_type;
	}
	public void setQna_type(String qna_type) {
		this.qna_type = qna_type;
	}
	public long getOrder_num() {
		return order_num;
	}
	public void setOrder_num(long order_num) {
		this.order_num = order_num;
	}
	public String getQna_title() {
		return qna_title;
	}
	public void setQna_title(String qna_title) {
		this.qna_title = qna_title;
	}
	public String getQna_content() {
		return qna_content;
	}
	public void setQna_content(String qna_content) {
		this.qna_content = qna_content;
	}
	public String getQna_date() {
		return qna_date;
	}
	public void setQna_date(String qna_date) {
		this.qna_date = qna_date;
	}
	public String getQna_file() {
		return qna_file;
	}
	public void setQna_file(String qna_file) {
		this.qna_file = qna_file;
	}
	public String getQna_check() {
		return qna_check;
	}
	public void setQna_check(String qna_check) {
		this.qna_check = qna_check;
	}
	public String getQna_scr() {
		return qna_scr;
	}
	public void setQna_scr(String qna_scr) {
		this.qna_scr = qna_scr;
	}
	public String getQna_pass() {
		return qna_pass;
	}
	public void setQna_pass(String qna_pass) {
		this.qna_pass = qna_pass;
	}

	
}
