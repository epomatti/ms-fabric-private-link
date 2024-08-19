package io.pomatti.app;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FabricController {

	@Autowired
	private Config config;

	@Value("${litware.connectionUrl}")
	private String jdbcUrl;

	@GetMapping("/")
	public String ok() {
		return "OK";
	}

	@GetMapping("/api/fabric/select1")
	public String select1() throws Exception {
		ResultSet resultSet = null;

		try (Connection connection = DriverManager.getConnection(jdbcUrl);
				Statement statement = connection.createStatement();) {

			// Create and execute a SELECT SQL statement.
			String selectSql = "SELECT 1";
			resultSet = statement.executeQuery(selectSql);

			// Print results from select statement
			var result = "";
			while (resultSet.next()) {
				result = resultSet.getString(1);
			}
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
	}

	@GetMapping("/api/fabric")
	public String api() {
		try (Connection connection = DriverManager.getConnection(config.getConnectionUrl());) {
			// Code here.
		}
		// Handle any errors that may have occurred.
		catch (SQLException e) {
			e.printStackTrace();
		}
		return "Customer";
	}

}
