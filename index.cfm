<!DOCTYPE html>

<script src="jquery-2.0.3.min.js" ></script>

<script >
	$(document).ready(function(){
		// EP. add an employee 
		$(document).on("click","#addBtn", function(){
			var lastName = $("#lnTxt").val();
			var firstName = $("#fnTxt").val();
			var address = $("#addressTxt").val();
			
			if (lastName.trim().length == 0)
			{
				alert("Last name is required");
				return;
			}
			
			addEmployee(lastName,firstName,address);
		});
	});
</script>

<style >
	th,td {
		text-align:left;
	}	
</style>

<h2>CFMobile Demo:</h2>
This application calls a CFC on the server side to get all employee records from a database table on the server.<br>
You can add an employee by filling up following details and clicking Submit button.
This again makes call to a server CFC to add employee to the table.

<h3>Add Employee:</h3>

<!--- EP. the form page --->

<form>
	<table >
		
		<tr>
			<td>Last Name:</td>
			<td><input type="text" id="lnTxt">		
		</tr>
		<tr>
			<td>First Name:</td>
			<td><input type="text" id="fnTxt">		
		</tr>
		<tr>
			<td>Address:</td>
			<td><input type="text" id="addressTxt">		
		</tr>
		<tr>
			<td colspan="2">
				<button type="button" id="addBtn">Add</button>
				<button type="reset">Reset</button>
			</td>
		</tr>
	</table>
</form>

<!--- EP. the results list --->
<hr>
<h3>Employees:</h3>
<table id="empTable" width="100%">
	<tr>
		<th>Last Name</th>
		<th>First Name</th>
		<th>City</th>
	</tr>
</table>


<!--- EP. start the magic --->
<cfclient>
	<cfscript>
		try
		{
			// EP. Create the server object from here, the client.
			empMgr = new EmpServerApp.EmployeeDBManager();
		}
		catch (any e)
		{
			alert("Error : " + e.message);
			cfabort ();
		}

		// EP. get all employees from the server and display them in the above HTML table
		getAllEmployees();
		
		// EP. Add a new employee.
		function addEmployee(lastName, firstName, address)
		{
			try
			{
				var newEmp = {"lastName":lastName, "firstName":firstName, "address":address};
				
				
				// Set callback function on the server CFC, which will be
				// called with the result.
				// EP. Note that it uses an annonymous function. 
				// EP. That's important because that makes it asyncronous and "NON BLOCKING"
				empMgr.setCallbackHandler(function(callbackResult) {
					newEmp.id = callbackResult.result;
					addEmpToHTMLTable(newEmp);
				});
				
				empMgr.addEmployee(newEmp);
			}
			catch (any e)
			{
				alert("Error:" + e.message);
				return;
			} 
		}
		
		//Fetch employees data from server and display in the HTML table
		function getAllEmployees()
		{
			try
			{
				//Set callback function on the server CFC, which will be
				//called with the result
				empMgr.setCallbackHandler(function(callbackResult){
					var employees = callbackResult.result;
					var empCount = arrayLen(employees);
					for (var i = 1; i <= empCount; i++)
					{
						addEmpToHTMLTable(employees[i]);	
					}
				});
				
				empMgr.getEmployees();
			}
			catch (any e)
			{
				alert("Error : " + e.message);
				return;
			}
			
		}
		
	</cfscript>
	
	<!--- Append employee data in the HTML table --->
	<cffunction name="addEmpToHTMLTable" >
		<cfargument name="emp" >
		
		<cfoutput >
			<cfsavecontent variable="rowHtml" >
				<tr>
					<td>#emp.lastName#</td>
					<td>#emp.firstName#</td>
					<td>#emp.address#</td>
				</tr>
			</cfsavecontent>
		</cfoutput>
		
		<cfset $("##empTable").append(rowHtml)>
	</cffunction>
	
</cfclient>