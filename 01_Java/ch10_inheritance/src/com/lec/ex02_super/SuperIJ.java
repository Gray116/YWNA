package com.lec.ex02_super;

public class SuperIJ {
	private int i;
	private int j;
	
	public SuperIJ() {
		System.out.println("매개변수 없는 SuperIJ 생성자 함수");
	}
	
	public SuperIJ(int i, int j) {
		this.i = i;
		this.j = j;
		
		System.out.println("매개변수 있는 SuperIJ 생성자 함수");
	}

	public int getI() {
		return i;
	}

	public void setI(int i) {
		this.i = i;
	}

	public int getJ() {
		return j;
	}

	public void setJ(int j) {
		this.j = j;
	}
	
}
