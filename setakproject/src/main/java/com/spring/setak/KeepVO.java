package com.spring.setak;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class KeepVO {
	int keep_seq;
	String keep_cate;
	String keep_kind;
	int keep_count;
	int keep_month;
	int keep_box;
	int keep_price;
	String keep_start;
	String keep_end;
	int keep_wash;
	String keep_now;
	
	public int getKeep_seq() {
		return keep_seq;
	}
	public void setKeep_seq(int keep_seq) {
		this.keep_seq = keep_seq;
	}
	public String getKeep_cate() {
		return keep_cate;
	}
	public void setKeep_cate(String keep_cate) {
		this.keep_cate = keep_cate;
	}
	public String getKeep_kind() {
		return keep_kind;
	}
	public void setKeep_kind(String keep_kind) {
		this.keep_kind = keep_kind;
	}
	public int getKeep_count() {
		return keep_count;
	}
	public void setKeep_count(int keep_count) {
		this.keep_count = keep_count;
	}
	public int getKeep_month() {
		return keep_month;
	}
	public void setKeep_month(int keep_month) {
		this.keep_month = keep_month;
	}
	public int getKeep_box() {
		return keep_box;
	}
	public void setKeep_box(int keep_box) {
		this.keep_box = keep_box;
	}
	public int getKeep_price() {
		return keep_price;
	}
	public void setKeep_price(int keep_price) {
		this.keep_price = keep_price;
	}
	public String getKeep_start() {
		return keep_start;
	}
	public void setKeep_start(String keep_start) {
		this.keep_start = keep_start;
	}
	public String getKeep_end() {
		return keep_end;
	}
	public void setKeep_end(String keep_end) {
		this.keep_end = keep_end;
	}
	public int getKeep_wash() {
		return keep_wash;
	}
	public void setKeep_wash(int keep_wash) {
		this.keep_wash = keep_wash;
	}
	public String getKeep_now() {
		return keep_now;
	}
	public void setKeep_now(String keep_now) {
		this.keep_now = keep_now;
	}
	
}