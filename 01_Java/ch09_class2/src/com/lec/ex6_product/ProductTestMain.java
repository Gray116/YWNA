package com.lec.ex6_product;

public class ProductTestMain {
	public static void main(String[] args) {
		System.out.println(Product.count);
		
		Product p1 = new Product("에어컨");
		p1.infoPrint();
		
		Product p2 = new Product("에어컨");
		p2.infoPrint();
	}
}