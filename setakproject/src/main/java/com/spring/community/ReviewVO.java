package com.spring.community;

public class ReviewVO 
{
	private int review_num;
	private String member_id;
	private String member_name;	
	private String review_kind;
	private Double review_star;
	private String review_content;
	private String review_like;
	private String review_photo;
	private String review_date;	
	private String keyfield;
	private String keyword;
	private String re_condition;
	/*
	 * public String getMember_name() { return member_name; } public void
	 * setMember_name(String member_name) { this.member_name = member_name; }
	 */
	
	public String getMember_name() {
		return member_name;
	}
	public void setMember_name(String member_name) {
		this.member_name = member_name;
	}
	public int getReview_num() {
		return review_num;
	}
	public void setReview_num(int review_num) {
		this.review_num = review_num;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getReview_kind() {
		return review_kind;
	}
	public void setReview_kind(String review_kind) {
		this.review_kind = review_kind;
	}
	public Double getReview_star() {
		return review_star;
	}
	public void setReview_star(Double review_star) {
		this.review_star = review_star;
	}
	public String getReview_content() {
		return review_content;
	}
	public void setReview_content(String review_content) {
		this.review_content = review_content;
	}
	public String getReview_like() {
		return review_like;
	}
	public void setReview_like(String review_like) {
		this.review_like = review_like;
	}
	public String getReview_photo() {
		return review_photo;
	}
	public void setReview_photo(String review_photo) {
		this.review_photo = review_photo;
	}
	public String getReview_date() {
		return review_date;
	}
	public void setReview_date(String review_date) {
		this.review_date = review_date;
	}
	public String getKeyfield() {
		return keyfield;
	}
	public void setKeyfield(String keyfield) {
		this.keyfield = keyfield;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getRe_condition() {
		return re_condition;
	}
	public void setRe_condition(String re_condition) {
		this.re_condition = re_condition;
	}


	
}
