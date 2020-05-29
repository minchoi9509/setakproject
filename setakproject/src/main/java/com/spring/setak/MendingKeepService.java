package com.spring.setak;

import com.spring.order.KeepCartVO;
import com.spring.order.MendingCartVO;
import com.spring.order.WashingCartVO;

public interface MendingKeepService {
	public int insertMending(MendingVO mending);
	public void insertMendingCart(MendingCartVO mendingcart);
	public int insertKeep(KeepVO keep);
	public void insertKeepCart(KeepCartVO keepcart);
	public int insertWash(WashingVO washing);
	public void insertWashingCart(WashingCartVO washingcart);
}
