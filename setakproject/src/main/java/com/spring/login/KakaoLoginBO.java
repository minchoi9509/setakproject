package com.spring.login;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
 

public class KakaoLoginBO {
    //카카오 서비스 url 설정 8000, 8080
	//카카오  redirect url 설정  8000, 8080
	private final static String CLIENT_ID = "4f8c1a40505b99c6a132a398726fe9df"; // 앱 생성시 발급 받는 rest api 키
	private final static String REDIRECT_URI ="http://localhost:8000/setak/kakao"; // 코드 리다이렉트 해줄 uri < 컨트롤러에서 이 부분으로 움직이는 거지! 
	
	
	public static String getAuthorizationUrl(HttpSession session) {
		String url = "https://kauth.kakao.com/oauth/authorize?client_id="+CLIENT_ID+"&redirect_uri="+REDIRECT_URI+"&response_type=code";
		return url;
	}

	
	public static JsonNode getKakaoAccessToken(String code) {
		 
        final String RequestUrl = "https://kauth.kakao.com/oauth/token"; 
        final List<NameValuePair> postParams = new ArrayList<NameValuePair>(); 
 
        postParams.add(new BasicNameValuePair("grant_type", "authorization_code"));
        postParams.add(new BasicNameValuePair("client_id", "4f8c1a40505b99c6a132a398726fe9df")); 
        postParams.add(new BasicNameValuePair("redirect_uri", "http://localhost:8000/setak/kakao")); 
        postParams.add(new BasicNameValuePair("code", code)); 
 
        final HttpClient client = HttpClientBuilder.create().build(); 
        final HttpPost post = new HttpPost(RequestUrl); 
 
        JsonNode returnNode = null;
 
        try {
            post.setEntity(new UrlEncodedFormEntity(postParams));
 
            final HttpResponse response = client.execute(post); 
            final int responseCode = response.getStatusLine().getStatusCode(); 
 
            ObjectMapper mapper = new ObjectMapper();
 
            returnNode = mapper.readTree(response.getEntity().getContent()); 
 
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (ClientProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
        }
 
        return returnNode;
    }
	
	
	 public static JsonNode getKakaoUserInfo(JsonNode accessToken) {
		 
	        final String RequestUrl = "https://kapi.kakao.com/v2/user/me";
	        final HttpClient client = HttpClientBuilder.create().build();
	        final HttpPost post = new HttpPost(RequestUrl);
	 
	        post.addHeader("Authorization", "Bearer " + accessToken); 
	 
	        JsonNode returnNode = null;
	 
	        try {
	            final HttpResponse response = client.execute(post);
	            final int responseCode = response.getStatusLine().getStatusCode();
	 
	            ObjectMapper mapper = new ObjectMapper();
	            returnNode = mapper.readTree(response.getEntity().getContent());
	 
	        } catch (ClientProtocolException e) {
	            e.printStackTrace();
	        } catch (IOException e) {
	            e.printStackTrace();
	        } finally {
	        }
	 
	        return returnNode;
	    }

	
}
 