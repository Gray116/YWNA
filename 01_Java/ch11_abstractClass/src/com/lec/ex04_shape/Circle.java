package com.lec.ex04_shape;

public class Circle extends Shape {
	private int r;
	
	public Circle(int r) {
		this.r = r;
	}

	@Override
	public void computeArea() {
		System.out.println("원의 넓이는 " + (3.14 * r * r)); // double 형으로 바꾸게 되면 return이 필요함. 
		// ex) return 3.14 * r * r
	}
	
	@Override
	public void draw() {
		System.out.print("원을 ");
		super.draw();
	}

}
