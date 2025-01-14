/* 1. 부서번호 검색, 해당 부서번호의 유무 확인 */
/* 2. 해당부서번호 없을 경우 : 부서명, 위치를 입력받아 INSERT */
/* 3. 해당부서번호 있을 경우 : 중복된 부서번호 입니다.*/

package com.lec.ex3insert;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class InsertDept2 {
	public static void main(String[] args) {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Scanner sc = new Scanner(System.in);
		
		System.out.print("부서번호 검색 : ");
		int deptno = sc.nextInt();
		
		String sql1 = "select *" + 
				"    from dept" + 
				"    where deptno = " + deptno;
		
		try {
			Class.forName(driver);
			conn = DriverManager.getConnection(url, "scott", "tiger");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql1);
			
			if (rs.next()) {
				System.out.println("중복된 부서번호입니다.");
			} else {
				System.out.println("해당부서 없음");
				
				System.out.print("부서이름 입력 : ");
				String dname = sc.next();
				
				System.out.print("부서위치 입력 : ");
				String loc = sc.next();
				
				String sql2 = "insert into dept" + 
						"    values ("+deptno+",'"+dname+"', '"+loc+"')";
				
				int result = stmt.executeUpdate(sql2);
				System.out.println(result == 1? "부서추가 성공" : "부사추가 실패");
			}
		} catch (ClassNotFoundException e) {
			System.out.println(e.getMessage());
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
				if (rs != null) rs.close();
				if (stmt != null) stmt.close();
				if (conn != null) conn.close();
			} catch (Exception e2) {}
		}
		sc.close();
	} // main
} // class