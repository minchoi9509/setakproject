package com.spring.order;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Iamport {
	
	public static final String import_cancel_url = "https://api.iamport.kr/payments/cancel";
	public static final String import_schedule_url = "https://api.iamport.kr/subscribe/payments/schedule";
	public static final String requestURL = "https://api.iamport.kr/users/getToken";
	
	public String getToken(HttpServletRequest request, HttpServletResponse response) throws Exception{

		String _token = "";
		

		try{
			
			// 아임포트 억세스 토큰생성
			String imp_key = URLEncoder.encode("9458449343571602", "UTF-8");
			String imp_secret = URLEncoder
					.encode("c78aAvqvXVnomnIQHgAPXG42aFDaIZGU7P4IludiqBGNYoDGFevCVzF5fjgYiWSqMX87slpSX6FWvjCa", "UTF-8");
			JSONObject json = new JSONObject();
			json.put("imp_key", imp_key);
			json.put("imp_secret", imp_secret);
			
			String requestString = "";
			URL url = new URL(requestURL);
			
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setDoOutput(true); 				
			connection.setInstanceFollowRedirects(false);  
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Content-Type", "application/json");

			OutputStream os= connection.getOutputStream();

			os.write(json.toString().getBytes());
			connection.connect();

			StringBuilder sb = new StringBuilder(); 

			if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
				
				BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "utf-8"));
				String line = null;  

				while ((line = br.readLine()) != null) {  
					sb.append(line + "\n");  
				}

				br.close();
				requestString = sb.toString();

			}

			os.flush();
			connection.disconnect();

			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObj = (JSONObject) jsonParser.parse(requestString);

			if((Long)jsonObj.get("code")  == 0){
				JSONObject getToken = (JSONObject) jsonObj.get("response");
				System.out.println("getToken==>>"+getToken.get("access_token") );
				_token = (String)getToken.get("access_token");
			}

		}catch(Exception e){
			e.printStackTrace();
			_token = "";
		}

		return _token;
	}
	
	
	public int cancelPayment(String token, String mid) {
		
		HttpClient client = HttpClientBuilder.create().build();
		HttpPost post = new HttpPost(import_cancel_url);
		Map<String, String> map = new HashMap<String, String>();
		post.setHeader("Authorization", token);
		map.put("merchant_uid",  mid);
		String asd = "";
		
		try {
			
			post.setEntity(new UrlEncodedFormEntity(convertParameter(map)));
			HttpResponse res = client.execute(post);
			ObjectMapper mapper = new ObjectMapper();
			String enty = EntityUtils.toString(res.getEntity());
			JsonNode rootNode = mapper.readTree(enty);
			asd = rootNode.get("response").asText();
			
		} catch(Exception e) {
			
			e.printStackTrace();

		}
		
		if(asd.equals("null")) {
			
			return -1;
			
		} else {
			
			return 1;
			
		}
	}
	
	public List<NameValuePair> convertParameter(Map<String, String> paramMap) {
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		Set<Entry<String, String>> entries = paramMap.entrySet();
		
		for(Entry<String, String> entry : entries) {
			paramList.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
		}
		
		return paramList;
	}
	
	// 정기결제 예약 취소 
	public int cancelSub(String token, String customer_uid) {
		String body = "{\"customer_uid\":\"" + customer_uid + "\"}";
		
		try {

			URL url = new URL("https://api.iamport.kr/subscribe/payments/unschedule");

			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setUseCaches(false);
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setRequestMethod("POST");
			con.setRequestProperty("content-type", "application/json");
			con.setRequestProperty("Authorization", token);
			con.setDoOutput(true);
			DataOutputStream wr = new DataOutputStream(con.getOutputStream());

			wr.write(body.getBytes());
			wr.flush();
			wr.close();

			int responseCode = con.getResponseCode();
			BufferedReader br;
			if (responseCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}

			String inputLine;
			StringBuffer responsebuffer = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				responsebuffer.append(inputLine);
			}
			br.close();

		} catch (Exception e) {
			System.out.println(e);
			return -1; 
		}
		
		return 1;
	}


	public HashMap<String, Object> getSchedule(String muid,String token) throws Exception{
		HashMap<String, Object> map = new HashMap<String, Object>(); 
		try{
			
			String requestString = "";
			String urlport = "https://api.iamport.kr/subscribe/payments/schedule/" + muid+"?_token="+token;
			URL url = new URL(urlport);
			
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setDoOutput(true); 				
			connection.setInstanceFollowRedirects(false);  
			connection.setRequestMethod("GET");
			connection.setRequestProperty("Content-Type", "application/json");

			OutputStream os= connection.getOutputStream();

			//os.write(json.toString().getBytes());
			connection.connect();

			StringBuilder sb = new StringBuilder(); 
			if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
				
				BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "utf-8"));
				String line = null;  

				while ((line = br.readLine()) != null) {  
					sb.append(line + "\n");  
				}

				br.close();
				requestString = sb.toString();

			}

			os.flush();
			connection.disconnect();

			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObj = (JSONObject) jsonParser.parse(requestString);

			if((Long)jsonObj.get("code")  == 0){
				JSONObject getinfo = (JSONObject) jsonObj.get("response");
				map.put("customer_uid", (String)getinfo.get("customer_uid"));
				map.put("amount", (long)getinfo.get("amount"));
			}

		}catch(Exception e){
			e.printStackTrace();
		}

		return map;
	}
	
	// 정기결제
	public void subsres(String cid, String mid, String amount, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		Calendar c = Calendar.getInstance();
		long time = c.getTimeInMillis() / 1000;
		time += 2678400;

		// 정기 결제 예약
		Iamport iamport = new Iamport();

		// 아임포트 억세스 토큰생성
		String token = iamport.getToken(request, response);

		String body = "{\"customer_uid\":\"" + cid + "\"," + "\"schedules\": [\r\n" + "{" + "\"merchant_uid\":" + "\""
				+ mid + "\"" + ",\r\n" + "\"schedule_at\":\"" + time + "\",\r\n" + "\"amount\":\"" + amount + "\""
				+ "}\r\n" + "]\r\n" + "}";

		try {

			URL url = new URL("https://api.iamport.kr/subscribe/payments/schedule");

			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setUseCaches(false);
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setRequestMethod("POST");
			con.setRequestProperty("content-type", "application/json");
			con.setRequestProperty("Authorization", token);
			con.setDoOutput(true);
			DataOutputStream wr = new DataOutputStream(con.getOutputStream()); 

			wr.write(body.getBytes());
			wr.flush();
			wr.close();

			int responseCode = con.getResponseCode();
			BufferedReader br;
			System.out.println(responseCode);
			if (responseCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			} 

			String inputLine;
			StringBuffer responsebuffer = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				responsebuffer.append(inputLine);
			}
			br.close();

			System.out.println(responsebuffer.toString());

		} catch (Exception e) {
			System.out.println(e);
		}

	}
	
	// 정기결제 재구독
	public void resub(String cid, String mid, String amount, long time, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		
		// 아임포트 억세스 토큰생성
		
		String token = this.getToken(request, response);		
		String body = "{\"customer_uid\":\"" + cid + "\"," + "\"schedules\": [\r\n" + "{" + "\"merchant_uid\":" + "\""
				+ mid + "\"" + ",\r\n" + "\"schedule_at\":\"" + time + "\",\r\n" + "\"amount\":\"" + amount + "\""
				+ "}\r\n" + "]\r\n" + "}";
		
		try {
			
			URL url = new URL("https://api.iamport.kr/subscribe/payments/schedule");
			
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setUseCaches(false);
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setRequestMethod("POST");
			con.setRequestProperty("content-type", "application/json");
			con.setRequestProperty("Authorization", token);
			con.setDoOutput(true);
			DataOutputStream wr = new DataOutputStream(con.getOutputStream());
			
			wr.write(body.getBytes());
			wr.flush();
			wr.close();
			
			int responseCode = con.getResponseCode();
			BufferedReader br;
			if (responseCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}
			
			String inputLine;
			StringBuffer responsebuffer = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				responsebuffer.append(inputLine);
			}
			br.close();
			
			
		} catch (Exception e) {
			System.out.println(e);
		}
		
	}
	
}
