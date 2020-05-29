package com.spring.api;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.services.s3.AmazonS3;
@Service
public class AWSServiceImpl implements AWSService {

	@Override
	public void multiImagesUpload(String ssn_num, MultipartFile[] file, AmazonS3 s3client) throws Exception {
		 String bucketName = "airbubblebucket";
		 
		 ImageUploadUtil.multiImagesUpload(ssn_num, file, s3client, bucketName);
	}

}
