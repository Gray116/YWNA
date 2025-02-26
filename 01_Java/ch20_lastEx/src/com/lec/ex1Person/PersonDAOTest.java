package com.lec.ex1Person;

import java.util.ArrayList;
import java.util.Vector;

public class PersonDAOTest {
	public static void main(String[] args) {
		PersonDAO dao = PersonDAO.getInstance(); //싱글턴 객체의 변수 초기화
		/* 1. 입력 */
		PersonDTO newPerson = new PersonDTO("배우", "박길동", 95, 90, 90);
		int result = dao.insertPerson(newPerson);
		
		System.out.println(result == PersonDAO.SUCCESSED? "입력 성공" : "입력 실패");
		
		/* 2. 직업별 조회 */
		ArrayList<PersonDTO> person = dao.selectJname("배우");
		
		System.out.println("배우 직업 조회 결과");
		for (PersonDTO p : person) {
			System.out.println(p.toString());
		}
		
		/* 3. 전체 출력 */
		person = dao.selectAll();
		System.out.println("전체");
		for (int idx=0; idx<person.size(); idx++) {
			System.out.println(person.get(idx));
		}
		
		/* 4. 직업리스트 */
		Vector<String> jnamelist = dao.jnameList();
		for (int idx = 0; idx < jnamelist.size(); idx++) {
			System.out.println(idx + "번째 : " + jnamelist.get(idx));
		}
			
	}
}