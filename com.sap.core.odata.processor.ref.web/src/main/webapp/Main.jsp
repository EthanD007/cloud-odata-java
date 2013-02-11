<%@page import="java.util.List"%>
<%@page import="javax.persistence.EntityManager"%>
<%@page import="javax.persistence.EntityManagerFactory"%>
<%@page import="javax.persistence.Persistence"%>
<%@page import="javax.persistence.Query"%>
<%@page
	import="com.sap.core.odata.processor.ref.JPAReferenceServiceFactory"%>
<%@page import="com.sap.core.odata.processor.ref.util.DataGenerator"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<script type="text/javascript">
	function toggle(expandId, iconId) {
		var item = document.getElementById(expandId);

		if (item.style.display == "block") {
			item.style.display = "none";
		} else {
			item.style.display = "block";
		}

		item = document.getElementById(iconId);
		if (item.innerHTML == "[ <b>.:</b> ]")
			item.innerHTML = "[ <b>:.</b> ]";
		else
			item.innerHTML = "[ <b>.:</b> ]";
	}
</script>
<style type="text/css">
body {
	font-family: "Arial";
	font-size: small;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Welcome to JPA implementation</title>
</head>
<body>
	<table width=100% cellpadding="3" cellspacing="3" bgcolor="#A6A6A6">
		<tr height="100%">
			<td height="100%" width="80%"><h2>SAP OData JPA Processor library</h2></td>
			<td width="20%" align="right"><img src="./image/SAPLogo.png"></td>
		</tr>
	</table>
	<hr>
	<table width="100%">
		<tr>
			<td width="70%"><font size=small><b>SalesOrderProcessing - Reference
					Scenario</b></font><small> [<a href="./image/model.png" target=_blank>Java
						Persistence Model</a>]
			</small></td>
			<td width="30%">
				<table cellspacing="1" cellpadding="1">
					<tr align="center">
						<td align="right" width="80%"><font color="green"><small>
									<%
										EntityManagerFactory entityManagerFactory = Persistence
												.createEntityManagerFactory("salesorderprocessing");
										EntityManager entityManager = entityManagerFactory
												.createEntityManager();
										DataGenerator dataGenerator = new DataGenerator(entityManager);

										Number result1 = null;
										Number existingCount = null;

										String msg = null;
										if (request.getParameter("button") != null) {
											if (request.getParameter("button").equalsIgnoreCase("Generate")) {
												Query q = entityManager
														.createQuery("SELECT COUNT(x) FROM SalesOrderHeader x");
												existingCount = (Number) q.getSingleResult();
												if (existingCount.intValue() == 0) { // Generate only if no data!
													dataGenerator.generate();
													result1 = (Number) q.getSingleResult();
													System.out
															.println("Data not existing earlier.... Generated number of Items - "
																	+ result1);
													msg = result1 + " items generated. ";

												} else {
													System.err
															.println("Data already existing.... No Item generated by Data Generator !!");
													msg = "Data exists. No Item generated !!";
												}
											} else { //Clean

												// Check if data already exists
												Query q = entityManager
														.createQuery("SELECT COUNT(x) FROM SalesOrderHeader x");
												Number result = (Number) q.getSingleResult();
												if (result.intValue() > 0) { // Generate only if no data!
													dataGenerator.clean();
													msg = "Data Cleaned. " + result + " items cleaned.";
												} else {
													msg = " Nothing to clean!!";
												}
											}
									%> <%=(msg)%>
							</small> </font></td>
						<%
							}
						%>
						<td width="10%">
							<form name="form1" method="get">
								<input type="hidden" name="button" value="Generate"> <input
									type="submit" value="Generate Data" width="100%">
							</form>
						</td>
						<td width="10%">

							<form name="form2" method="get">
								<input type="hidden" name="button" value="Clean"> <input
									type="submit" value="   Clean Data  " width="100%">
							</form>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<hr>
	<table width=100% cellspacing="1">
		<tr>
			<td width="2%">
				<div id="s1e" onClick="toggle('s1','s1e');"
					style="cursor: hand; cursor: pointer; color: blue; width: 100%;">
					[ <b>:.</b> ]
				</div>
			</td>
			<td width="98%"><b>Service Document and Metadata</b></td>
		</tr>
	</table>


	<div id="s1" style="display: none">
		<ul>
			<li><a href="SalesOrderProcessing.svc?_wadl" target="_blank">wadl</a></li>
			<li><a href="SalesOrderProcessing.svc/" target="_blank">service
					document</a></li>
			<li><a href="SalesOrderProcessing.svc/$metadata" target="_blank">metadata</a></li>
		</ul>
	</div>


	<table width=100% cellspacing="1">
		<tr>
			<td width="2%">
				<div id="s2e" onClick="toggle('s2','s2e');"
					style="cursor: hand; cursor: pointer; color: blue; width: 100%;">
					[ <b>:.</b> ]
				</div>
			</td>
			<td width="98%"><b>System Query Options</b></td>
		</tr>
	</table>

	<div id="s2" style="display: none">
		<table width=100% border="1" cellpadding="3" cellspacing="0">

			<tr bgcolor="#F0F0F0">
				<th align="left">Use Case</th>
				<th align="left">OData Request</th>
				<th align="left">JPQL Statement</th>
			</tr>

			<tr>
				<td width=20%>Query all Sales Orders</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders" target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders
				</a></td>
				<td width=40%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1</code></td>
			</tr>
			<tr>
				<td width=20%>Query for Sales Order with So ID = 1</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$filter=SoId eq 1"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$filter=SoId
						eq 1</a></td>
				<td width=40%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1
						WHERE E1.soId = 1</code></td>
			</tr>
			<tr>
				<td>Query for Sales Order with Buyer Name = buyerName_3</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$filter=BuyerName eq 'buyerName_3'"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$filter=BuyerName
						eq 'buyerName_3'</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1
						WHERE E1.buyerName = 'buyerName_3'</code></td>
			</tr>
			<tr>
				<td>Query for undelivered Sales Orders</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$filter=DeliveryStatus eq false"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$filter=DeliveryStatus
						eq false</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1
						WHERE E1.deliveryStatus = 'false'</code></td>
			</tr>
			<tr>
				<td>Query for Sales Order creation date</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$filter=CreationDate eq datetime'2013-01-01T00:00:00'"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$filter=CreationDate
						eq datetime'2013-01-01T00:00:00'</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1 WHERE E1.creationDate = {d '2013-01-01'}</code></td>
			</tr>
			<tr>
				<td>Query for Sales Order with Buyer Address House number = 7</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$filter=BuyerAddress/HouseNumber eq 7"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$filter=BuyerAddress/HouseNumber
						eq 7 </a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1 WHERE E1.buyerAddress.houseNumber = 7</code></td>
			</tr>
			<tr>
				<td>Query for SalesOrders with buyer id less than 5 and Buyer
					Country = Test_Country_3</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$filter=BuyerId le 5 and BuyerAddress/Country eq 'Test_Country_3'"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$filter=BuyerId
						le 5 and BuyerAddress/Country eq 'Test_Country_3'</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1
						WHERE E1.buyerId &lt; 5 and E1.buyerAddress.Country =
						'Test_Country_3'</code></td>
			</tr>
			<tr>
				<td>Query for SalesOrders with buyer id less than 5 or Sales
					Order Id greater than 5</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$filter=BuyerId le 5 or SoId gt 5"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$filter=BuyerId
						le 5 or SoId gt 5</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1
						WHERE E1.buyerId &lt; 5 or E1.soId &gt; 5 </code></td>
			</tr>
			<tr>
				<td>Query for SalesOrders in the descending order of Buyer Id</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$orderby=BuyerId desc"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$orderby=BuyerId
						desc</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1
						ORDERBY E1.buyerId desc </code></td>
			</tr>
			<tr>
				<td>Query for SalesOrders in the ascending order of Sales Order
					Id</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$orderby=SoId asc"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$orderby=SoId
						asc</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1
						ORDERBY E1.soId </code></td>
			</tr>
			<tr>
				<td>Query for top 3 SalesOrders</td>
				<td><a href="SalesOrderProcessing.svc/SalesOrderHeaders?$top=3"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$top=3</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1</code></td>
			</tr>
			<tr>
				<td>Query for SalesOrders and Skip top 3</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$skip=2"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$skip=2</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1</code></td>
			</tr>
			<tr>
				<td>Query for SalesOrders and count Number of Sales Orders
					Inline</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$inlinecount=allpages"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$inlinecount=allpages</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1</code></td>
			</tr>
			<tr>
				<td>Mixed Query Example</td>
				<td><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders?$skip=2&$top=2&$orderby=SoId"
					target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders?$skip=2&amp;$top=2&amp;$orderby=SoId</a></td>
				<td width=60%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1
						ORDERBY E1.soId asc</code></td>
			</tr>
		</table>
	</div>

	<table width=100% cellspacing="1">
		<tr>
			<td width="2%">
				<div id="s3e" onClick="toggle('s3','s3e');"
					style="cursor: hand; cursor: pointer; color: blue; width: 100%;">
					[ <b>:.</b> ]
				</div>
			</td>
			<td width="98%"><b>Read Operations</b></td>
		</tr>
	</table>
	
	<div id="s3" style="display: none">
		<table width=100% border="1" cellpadding="3" cellspacing="0">

			<tr bgcolor="#F0F0F0">
				<th align="left">Use Case</th>
				<th align="left">OData Request</th>
				<th align="left">JPQL Statement</th>
			</tr>
			
			<tr>
				<td width=20%>Read operation on SalesOrderHeader</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders(1L)" target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders(1L)
				</a></td>
				<td width=40%><code style="font-size: small">SELECT E1 FROM SalesOrderHeader E1 WHERE E1.soId = 1</code></td>
			</tr>
			<tr>
				<td width=20%>Read operation on SalesOrderItem</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/SalesOrderItems(SoId=1L,LiId=111L)" target="_blank">SalesOrderProcessing.svc/SalesOrderItems(SoId=1L,LiId=111L)
				</a></td>
				<td width=40%><code style="font-size: small">SELECT E1 FROM SalesOrderItem E1 WHERE E1.salesOrderItemKey.soId = 1 AND E1.salesOrderItemKey.liId = 111</code></td>
			</tr>
			<tr>
				<td width=20%>Read operation on Material</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/Materials(111L)" target="_blank">SalesOrderProcessing.svc/Materials(111L)
				</a></td>
				<td width=40%><code style="font-size: small">SELECT E1 FROM Material E1 WHERE E1.materialId = 111</code></td>
			</tr>
			<tr>
				<td width=20%>Read operation on Store</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/Stores(131L)" target="_blank">SalesOrderProcessing.svc/Stores(131L)
				</a></td>
				<td width=40%><code style="font-size: small">SELECT E1 FROM Material E1 WHERE E1.storeId = 131</code></td>
			</tr>
			
		</table>
	</div>
	
	<table width=100% cellspacing="1">
		<tr>
			<td width="2%">
				<div id="s4e" onClick="toggle('s4','s4e');"
					style="cursor: hand; cursor: pointer; color: blue; width: 100%;">
					[ <b>:.</b> ]
				</div>
			</td>
			<td width="98%"><b>Resource Navigation</b></td>
		</tr>
	</table>
	
	<div id="s4" style="display: none">
		<table width=100% border="1" cellpadding="3" cellspacing="0">

			<tr bgcolor="#F0F0F0">
				<th align="left">Use Case</th>
				<th align="left">OData Request</th>
				<th align="left">JPQL Statement</th>
			</tr>
			
			<tr>
				<td width=20%>SalesOrderHeader-SalesOrderItem (OneToMany)</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/SalesOrderHeaders(1L)/SalesOrderItemDetails" target="_blank">SalesOrderProcessing.svc/SalesOrderHeaders(1L)/SalesOrderItemDetails
				</a></td>
				<td width=40%><code style="font-size: small">SELECT R1 FROM SalesOrderHeader E1 JOIN E1.salesOrderItem R1 WHERE E1.soId = 1</code></td>
			</tr>
			
			<tr>
				<td width=20%>SalesOrderItem-SalesOrderHeader (ManyToOne)</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/SalesOrderItems(SoId=1L,LiId=111L)/SalesOrderHeaderDetails" target="_blank">SalesOrderProcessing.svc/SalesOrderItems(SoId=1L,LiId=111L)/SalesOrderHeaderDetails
				</a></td>
				<td width=40%><code style="font-size: small">SELECT R1 FROM SalesOrderItem E1 JOIN E1.salesOrderHeader R1 WHERE E1.salesOrderItemKey.soId = 1 AND E1.salesOrderItemKey.liId = 111</code></td>
			</tr>
			
			<tr>
				<td width=20%>SalesOrderItem-Material (ManyToOne)</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/SalesOrderItems(SoId=1L,LiId=111L)/MaterialDetails" target="_blank">SalesOrderProcessing.svc/SalesOrderItems(SoId=1L,LiId=111L)/MaterialDetails
				</a></td>
				<td width=40%><code style="font-size: small">SELECT R1 FROM SalesOrderItem E1 JOIN E1.material R1 WHERE E1.salesOrderItemKey.soId = 1 AND E1.salesOrderItemKey.liId = 111</code></td>
			</tr>
			
			<tr>
				<td width=20%>Material-Store (ManyToMany)</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/Materials(111L)/StoreDetails" target="_blank">SalesOrderProcessing.svc/Materials(111L)/StoreDetails
				</a></td>
				<td width=40%><code style="font-size: small">SELECT R1 FROM Material E1 JOIN E1.store R1 WHERE E1.materialId = 111</code></td>
			</tr>
			
			<tr>
				<td width=20%>Storage-Material (ManyToMany)</td>
				<td width=40%><a
					href="SalesOrderProcessing.svc/Stores(131L)/MaterialDetails" target="_blank">SalesOrderProcessing.svc/Stores(131L)/MaterialDetails
				</a></td>
				<td width=40%><code style="font-size: small">SELECT R1 FROM Store E1 JOIN E1.material R1 WHERE E1.storeId = 131</code></td>
			</tr>			
		</table>
	</div>	
	<hr>
</body>
</html>