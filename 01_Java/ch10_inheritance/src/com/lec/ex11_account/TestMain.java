package com.lec.ex11_account;

public class TestMain {
	public static void main(String[] args) {
		Account a1 = new Account("111-111","ȫ�浿",1000);
		CheckingAccount a2 = new CheckingAccount("222-222", "������", 2000, "1234-5678-9101-1121");
		CreditLineAccount a3 = new CreditLineAccount("333-333", "������", 20000, "1111-2222-3333-4444", 10000);
		
		a1.deposit(9000);
		a1.withdraw(20000);
		a2.withdraw(1000);
		a2.pay("1234-5678-9101-1121", 1000);
		a3.pay("1111-2222-3333-4444", 15000);
	}
}