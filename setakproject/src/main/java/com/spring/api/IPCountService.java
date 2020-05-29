package com.spring.api;

public interface IPCountService {
	int getIPList(String member_ip);
	int countIP(String member_ip);
	void insertIP(String member_ip);
	void plusIPCount(String member_ip);
}
