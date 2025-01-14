package com.lec.ex4_Quiz;

public class Customer {
	private String name;
	private String tel;
	private String address;
	
	public Customer() {}
	public Customer(String name, String tel, String address) {
		this.name = name;
		this.tel = tel;
		this.address = address;
	}
	
	@Override
	public String toString() {
		return "\t" + name + "\t" + tel + "\t" + address;
	}
	
	@Override
	public boolean equals(Object obj) {
		if(obj != null && obj instanceof Customer) {
			return toString().equals(obj.toString());
		} else {
			return false;
		}
	}
	
	public String getName() {
		return name;
	}
	public String getTel() {
		return tel;
	}
	public String getAddress() {
		return address;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public void setAddress(String address) {
		this.address = address;
	}
}