package com.lec.ex07_super_dot;

public class ChildClass extends ParentClass {
	private String cStr = "자식 클래스";
	
	public ChildClass() {
		System.out.println("자식 생성자");
	}
	
	@Override
	public void getMamiName() {
		System.out.print("이쁜 아주 이쁜 ");
		// super.은 부모 클래스의 
		super.getMamiName();
	}
}