package com.spring.api;

import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.services.s3.AmazonS3;

public interface AWSService {
	
	public void multiImagesUpload(String ssn_num, MultipartFile[] file, AmazonS3 s3client) throws Exception;
	 
}
