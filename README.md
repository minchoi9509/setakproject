# setakproject
1인 가구를 위한 세탁, 수선, 보관 서비스  
<br/>


### :pushpin: 목적 및 개요
1인 가구가 급증하는 한국 사회의 인구구조 변화에 발맞추어 온라인으로 편리하게 세탁, 수선, 보관을 한번에 신청할 수 있는 세탁 서비스 개발
#### &nbsp;&nbsp; :bulb: 기존 서비스와의 차별점
1. 1인 가구들의 부족한 생활 공간을 위한 `의류 보관` 서비스
2. `정기구독 요금제`를 통한 할인 방식 제공
3. `당일 수거` 서비스

<br/>

### :pushpin: 사용 기술
__SERVER__  
* tomcat8

__DATABASE__  
* Oracle

__LANGUAGE & FRAMEWORK__  
* JAVA
* JSP
* Spring
* Mybatis

__FRONT-END__  
* HTML
* CSS
* JavaScript
* jQuery
* AJAX

__TOOL__  
* Github
* Kakao OVEN
* EXERD

__API__  
* I'mport
* Kakao Login
* Naver Login, Storage
* Google Login 
* Daum Postcode

### :pushpin: 소스 코드
[1. ver 1.0 (team)](https://github.com/HiddenNPC/setakgom)   
[2. ver 2.0 (personal)](https://github.com/minchoi9509/setakproject)   
#### &nbsp;&nbsp; :bulb: 추가 및 변동 사항  
  자세한 내용은 [티스토리](https://minchoi0912.tistory.com/category/%EB%B9%84%ED%8A%B8%EC%BA%A0%ED%94%84%282019.09~%29)에서 확인 가능  
* 유사한 `코드 중복` 정리 (장바구니, 결제, QNA)  
* `QNA 페이지 게시판` 구현 + 댓글, 비밀글 
* Ajax를 통한 `페이징` 처리
* `관리자 페이지` > 메인 오늘의 일정 fullCalendar.js, `메뉴` 디자인   

### :pushpin: 구현 파트

주문`(장바구니, 결제)`, 정기구독 관련 파트를 맡아서 구현함 + QnA 게시판 코드 따로 구현    
관리자 페이지 `메인`, `주문관리`, `정기구독 관리`, `차트` 파트 구현    

<br/>

&nbsp; :bulb: __주문__
![슬라이드2](https://user-images.githubusercontent.com/53928609/83320063-d0bf5300-a27e-11ea-990e-4666341a0cfa.PNG)   
<br/>

&nbsp; :bulb: __정기구독__
![슬라이드3](https://user-images.githubusercontent.com/53928609/83320086-0cf2b380-a27f-11ea-98b0-81b9b38226e1.PNG)    
<br/>

&nbsp; :bulb: __QnA__
![슬라이드4](https://user-images.githubusercontent.com/53928609/83320088-1714b200-a27f-11ea-8133-0e1ab480a051.PNG)


### :pushpin: 구현 중 겪었던 어려움과 아쉬운 점
#### 어려웠던 점
 * __API, 외부 라이브러리 사용__   
결제, 차트, 달력 등 다양한 기능들을 위해 다양한 open api, 외부 라이브러리들을 사용해야 했음.   
--> 원하는 기능을 구현하기 위해서는 검색을 통해서는 한계가 명확했고 docs을 참고해 문제를 해결하는 방법을 많이 배웠음.   

* __중복 코드에 대한 고민__   
다른 페이지에서 같은 기능을 하는 경우가 많아지면서 중복되는 코드가 많아졌음.   
--> 추후 확장이 필요하다고 생각하는 페이지나 기능은 합치지 않았고 똑같은 기능만을 하는 경우 **클래스나 함수 생성**을 통해서 중복 코드를 줄여나갔음.   

* __여러 테이블을 이용하는 SQL문 생성__   
QnA 게시판 리스트를 구현 할 때 2개 이상의 테이블을 참조할 필요가 있었음.    
--> 책과 검색을 통해서 개념을 명확하게 하고 여러 방식들을 찾아보았음. 방법을 꽤 오랫동안 찾지 못해 SQL문을 분리해서 해결 하려고도 했으나 계속해서 [여러 방식으로 시도](https://minchoi0912.tistory.com/86?category=862541)끝에 하나의 SQL문을 통해서 원하는 리스트를 반환 할 수 있도록 문제 해결했음.    
```xml
<select id="getQnaList" parameterType="java.util.HashMap" resultMap="hashmapVO">
		select * from (select rownum as rnum, s.* from (
		select q.*, m.member_name FROM (select distinct(q.qna_num), q.member_id, q.qna_type,  q.order_num, q.qna_title, q.qna_content,      q.qna_date, .qna_file, q.qna_check, q.qna_scr, q.qna_pass, (select count(*) from qna_reply where qna_num = q.qna_num) as reply_cnt 
		from qna q, qna_reply qr order by qna_num) q, member m where q.member_id = m.member_id ORDER BY qna_num desc) s)
		where rnum between ${startrow} and ${endrow}
</select>
```


### :pushpin: 기타
&nbsp; :bulb: __DB 구조(ERD)__  
&nbsp; Member 테이블을 중심으로 총 24개의 테이블  
<br/>
![K-015](https://user-images.githubusercontent.com/53928609/80271271-be8b4b80-86f9-11ea-9fd9-c8d2ddd1ceb7.png)  
<br/>
&nbsp; :bulb: __시연영상__  
[발표영상](https://youtu.be/PH6KO_epTbw)
