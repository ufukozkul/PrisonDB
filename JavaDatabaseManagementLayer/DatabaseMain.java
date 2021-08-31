import java.util.Scanner;
import java.sql.*;
import java.text.SimpleDateFormat;

import org.postgresql.core.*;

public class DatabaseMain {

	private static Connection connection = null;
	private static Statement statement = null;
	private static ResultSet resultSet = null;

	final private static String host = "jdbc:postgresql://10.98.98.61:5432/group63";
	final private static String user = "group63";
	final private static String password = "!CMZx9=mghQ?GxHq";

	public static void main(String[] args) throws SQLException {
		// TODO Auto-generated method stub
		String name = "";
		String incarceration = "";
		String releaseDate = "";
		String haschild = "";
		String sex = "";
		String birthdate = "";
		String phonenumber = "";
		String educationdegree = "";
		String height = "";
		String weight = "";
		// -----------
		String tableName = "";
		String attribute = "";
		String val = "";

		// -----------------
		String attributes[];
		String oldVals[];
		String newVals[];
		String where = "";

		String greqleq = "";
		String columnNames = "";

		try {
			connection = DriverManager.getConnection(host, user, password);
			System.out.println("Connected to the database.");
			Scanner scanner = new Scanner(System.in);
			String input = "";

			do {
				statement = connection.createStatement();

				System.out.println("\nEnter 1 to insert the table");
				System.out.println("Enter 2 to update to the table");
				System.out.println("Enter 3 to delete from tables");
				System.out.println("Enter 4 to print the table");
				input = scanner.nextLine();
				switch (input) {
				case "1":
					System.out.println("Enter convict name:");
					name = scanner.nextLine();
					System.out.println("Enter incarceration date:(YYYY-MM-DD HH:MM:SS)");
					incarceration = scanner.nextLine();
					System.out.println("Enter release date:(YYYY-MM-DD HH:MM:SS)");
					releaseDate = scanner.nextLine();
					System.out.println("Enter haschild(true/false):");
					haschild = scanner.nextLine();
					System.out.println("Enter sex(male/female):");
					sex = scanner.nextLine();
					System.out.println("Enter birthdate(YYYY-MM-DD):");
					birthdate = scanner.nextLine();
					System.out.println("Enter phonenumber(max 20 character):");
					phonenumber = scanner.nextLine();
					System.out.println("Enter educationdegree(primary/secondary/bachelor/masters/doctorate):");
					educationdegree = scanner.nextLine();
					System.out.print("Enter height: ");
					height = scanner.nextLine();
					System.out.print("\nEnter weight: ");
					weight = scanner.nextLine();
					System.out.println();

					Insert(name, incarceration, releaseDate, haschild, sex, birthdate, phonenumber, educationdegree,
							height, weight);
					break;

				case "2":
					System.out.println("Enter the table name to update:");
					tableName = scanner.nextLine();

					System.out.println("The available column names to be set are: ");
					try {
						System.out.println(ColumnNames(tableName));
					} catch (Exception e) {
						System.out.println(tableName + " does not exist!");
						System.out.println();
						break;
					}

					System.out.println("\n\nSpecify conditions combined with and/or:");
					System.out.println("Example: name='Hello World' or id='5' ");
					// set where statement
					where = scanner.nextLine();

					System.out.println(
							"Which columns will be updated(seperated by one comma followed by one white space between attributes):");
					input = scanner.nextLine();
					attributes = input.split(", ");

					System.out.println(
							"Enter the new values(in order, seperated by one comma followed by one white space between attributes):");
					val = scanner.nextLine();
					newVals = val.split(", ");

					Update(tableName, where, attributes, newVals);
					break;

				case "3":
					System.out.println("Enter the table name to delete");
					tableName = scanner.nextLine();

					System.out.println("The available columns are: ");
					try {
						System.out.println(ColumnNames(tableName));
					} catch (Exception e) {
						System.out.println(tableName + " does not exist!");
						System.out.println();
						break;
					}
					System.out.println("\n\nEnter the identifying attribute");
					attribute = scanner.nextLine();

					System.out.println("Enter the attribute value");
					val = scanner.nextLine();

					Deletion(tableName, attribute, val);
					break;
				case "4":
					System.out.println("Enter the table name to print");
					tableName = scanner.nextLine();

					System.out.println("The available columns are: ");
					try {
						System.out.println(ColumnNames(tableName));
					} catch (Exception e) {
						System.out.println(tableName + " does not exist!");
						System.out.println();
						break;
					}
					System.out.println(
							"\n\nEnter the columns you want to display(seperated by one comma followed by one white space)");
					System.out.println("Write \"all\" if you want to print all");

					columnNames = scanner.nextLine();

					if (!columnNames.equals("all")) {
						System.out.println("Specify conditions combined with and/or:");
						System.out.println("Example: name='Hello World' or id='5'");
						// set where statement
						where = scanner.nextLine();
					}

					Print(tableName, columnNames, where);

					break;

				default:
					break;
				}
			} while (!input.equalsIgnoreCase("exit"));

			close();

		} catch (Exception e) {
			System.out.println("Connection cannot be established.");
		}

	}

	public static void Update(String tableName, String where, String attributes[], String newVals[]) {
		// to update a table, we need to get its columns
		try {
			String settings = "";
			if (attributes.length != newVals.length)
				return;

			for (int i = 0; i < attributes.length; i++) {
				settings += attributes[i] + "='" + newVals[i] + "', ";
			}
			settings = settings.substring(0, settings.length() - 2);

			statement = connection.createStatement();
			statement.executeUpdate("update " + tableName + " set " + settings + " where " + where);

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("Invalid update operation!");
		}
	}

	public static void Insert(String name, String incarcerationdate, String releaseDate, String haschild, String sex,
			String birthdate, String phonenumber, String educationdegree, String height, String weight) {
		// insert to convicts table
		// when inserting to the table, dont set id as it will be handled by sql table
		try {
			statement = connection.createStatement();

			statement.executeUpdate(
					"insert into convicts (name, incarcerationdate, releasedate, haschild, sex, birthdate, phonenumber, educationdegree, height, weight)\n"
							+ "values ('" + name + "', '" + ConvertToTimestamp(incarcerationdate) + "', '"
							+ ConvertToTimestamp(releaseDate) + "', '" + ConvertToBooleanStr(haschild) + "', '"
							+ ConvertToSex(sex) + "', '" + ConvertToDate(birthdate) + "', '" + phonenumber + "', '"
							+ educationdegree + "', " + height + ", " + weight + ");" + "");

		} catch (SQLException e) {
			System.out.println("Invalid insert operation!");
		}

	}

	public static void Deletion(String tableName, String attribute, String val) {
		try {
			statement = connection.createStatement();

			statement.executeUpdate("DELETE FROM " + tableName + " WHERE " + attribute + "='" + val + "'  ");
		} catch (SQLException e) {
			System.out.println("Delete failed. Please check again\n");
		}

	}

	private static void close() {
		try {
			if (resultSet != null) {
				resultSet.close();
			}
			if (statement != null) {
				statement.close();
			}
			if (connection != null) {
				connection.close();
			}
		} catch (Exception e) {
			System.out.println("Cannot close!");

		}
	}

	public static void Print(String tableName, String columnNames, String where) {
		ResultSetMetaData rsmd;
		try {
			if (columnNames.equals("all")) {
				columnNames = "*";
				resultSet = statement.executeQuery("select " + columnNames + " from " + tableName);

			} else {
				resultSet = statement.executeQuery("select " + columnNames + " from " + tableName + " where " + where + ";");

			}

			rsmd = resultSet.getMetaData();
			int columnCount = rsmd.getColumnCount();

			// list column names
			for (int i = 1; i <= columnCount; i++) {
				String name = rsmd.getColumnName(i);
				System.out.printf("%-50s", (name).trim());
			}
			System.out.println("");

			while (resultSet.next()) {
				for (int i = 1; i <= columnCount; i++) {
					System.out.printf("%-50s", (resultSet.getString(i).trim() + ""));
				}
				System.out.println();
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("Invalid print operation!");

		}

	}

	public static String ColumnNames(String tableName) throws SQLException {

		Statement state;
		state = connection.createStatement();
		ResultSet r = statement.executeQuery("select * from " + tableName);

		ResultSetMetaData rsmd;
		rsmd = r.getMetaData();
		int columnCount = rsmd.getColumnCount();

		String returned = "(";

		// list column names
		for (int i = 1; i < columnCount; i++) {
			String name = rsmd.getColumnName(i);
			returned += name + ", ";
		}
		returned += rsmd.getColumnName(columnCount);
		returned += ")";
		return returned;

	}

	public static String ConvertToBooleanStr(String s) {
		if (s.equals("true"))
			return "true";
		else
			return "false";
	}

	public static String ConvertToTimestamp(String s) {
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		try {
			Timestamp.valueOf(s);
			return s;

		} catch (Exception e) {
			return timestamp.toString();
		}
	}

	public static String ConvertToDate(String s) {
		try {

			return s;

		} catch (Exception e) {
			System.out.println("Invalid Date");
			return "0001-01-01";
		}
	}

	public static String ConvertToSex(String s) {
		if (s.equals("female"))
			return "female";

		return "male";
	}
}
