package com.spring.mapper;

public interface IPCountMapper {
	
	int getIPList(String member_ip);
	int countIP(String member_ip);
	void insertIP(String member_ip);
	void plusIPCount(String member_ip);
	
}
