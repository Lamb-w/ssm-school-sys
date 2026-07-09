package com.javaee.po;

import java.io.Serializable;
import java.sql.Date;

public class IdCard implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private int id;
	private String cardNo, issuingAuthority;
	private Date expireDateStart, expireDateEnd; // 因为有效期只考虑年月日，所以是java.sql.Date，而不是java.util.Date
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCardNo() {
		return cardNo;
	}
	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}
	public String getIssuingAuthority() {
		return issuingAuthority;
	}
	public void setIssuingAuthority(String issuingAuthority) {
		this.issuingAuthority = issuingAuthority;
	}
	public Date getExpireDateStart() {
		return expireDateStart;
	}
	public void setExpireDateStart(Date expireDateStart) {
		this.expireDateStart = expireDateStart;
	}
	public Date getExpireDateEnd() {
		return expireDateEnd;
	}
	public void setExpireDateEnd(Date expireDateEnd) {
		this.expireDateEnd = expireDateEnd;
	}
	
}