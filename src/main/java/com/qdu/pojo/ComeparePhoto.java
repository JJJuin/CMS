package com.qdu.pojo;

import java.io.Serializable;

public class ComeparePhoto implements Serializable{

	/**
	 * 比较照片，储存比较结果
	 */
	private static final long serialVersionUID = 1L;
	
	private int cppId;
	private int scoreId;
	private String cppTime;
	private String cppResult;
	private String chertAddress;
	
	
	public int getCppId() {
		return cppId;
	}
	public void setCppId(int cppId) {
		this.cppId = cppId;
	}
	
	public int getScoreId() {
		return scoreId;
	}
	public void setScoreId(int scoreId) {
		this.scoreId = scoreId;
	}
	public String getCppTime() {
		return cppTime;
	}
	public void setCppTime(String cppTime) {
		this.cppTime = cppTime;
	}
	public String getCppResult() {
		return cppResult;
	}
	public void setCppResult(String cppResult) {
		this.cppResult = cppResult;
	}
	public String getChertAddress() {
		return chertAddress;
	}
	public void setChertAddress(String chertAddress) {
		this.chertAddress = chertAddress;
	}
	
	

}
