  <!-- #include file="inc/header.inc" -->
  <h1>&nbsp;</h1>
  <div class="auction1" style="position:relative;top:-100px">
  
    <div class="shoptitle">
      <span style="font-size:32">Bid On Sellers' Auction Items</span>
    </div>
    <p>
      &nbsp;
    </p>
<div style="width:1000px;height:240px;">
  <img src="/graphics/images/bid-banner.png">
</div>
    <p>
      &nbsp;
    </p>

<div class="l-b2c__title" style="font-size:12px"><em>All you need to begin purchasing items is to have a free priceBay account and a paypal account upon sign up</em></div>
<br>
<!--<img src="/graphics/images/ppez.png">-->

    <%
    Server.ScriptTimeout = 1000

    dim ssql

    dim c, d

    c = request.querystring("c")

    d = request.querystring("d")

    if c = "" then

      c = 1

      d = 19

    end if
    
    ssql = "WITH sellProds AS "

    ssql = ssql & "("
    ssql = ssql & "    SELECT id, image, name, username, duration,"
    ssql = ssql & "    ROW_NUMBER() OVER (ORDER BY id DESC) AS 'RowNumber'"
    ssql = ssql & "    FROM sellproducts"
    ssql = ssql & ") "
    ssql = ssql & "SELECT * "
    ssql = ssql & "FROM sellProds "
    ssql = ssql & "WHERE RowNumber BETWEEN "&c&" AND "&d&";"

    set oRS = oConnection.Execute(ssql)

    dim count
    count = 0

    while not oRS.eof

    if count mod 21 = 0 then
    %>
      <div style = "width:900px;float:left">
<%
      if count = 0 and c <> 1 then
%>
      <div style = "float:left; width: 50px; height: 30px">
      <a href='buyproducts.asp?c=<%=c-4%>&d=<%=d-4%>'>less...</a>
      </div>
<%
      end if

    end if

    sqlstr = "SELECT * FROM mustpay WHERE itemid='" & oRS("id") & "'"

    set RS = oConnection.Execute(sqlstr)

    dim closed

    if RS.eof then
      closed = true

    %>
    <div style = "float:left; width: 160; height: 230;border:1px solid white;">
        <br><a href='auction.asp?id=<%=oRS("id")%>'><%=oRS("name")%></a>
        <br>Seller: <a href='auction.asp?id=<%=oRS("id")%>'><%=oRS("username")%></a>
        <br>Opened for: <%=oRS("duration")%> days
        <a href='auction.asp?id=<%=oRS("id")%>'><img src='/productitems/<%=oRS("image")%>' width="100" height="100"></a>
    </div>
    <%
    else
    %>
    <div style = "float:left; width: 160; height: 230;border:1px solid white;">
        <br><%=oRS("name")%>
        <br>Seller: <%=oRS("username")%>
        <br><span style="color:red">Auction closed</span>
        <img src='/productitems/<%=oRS("image")%>' width="100" height="100">
    </div>
    <%
    end if

    if count = d - 1 then
%>
<%
    end if

    if count mod 21 = 20 then
    %>
      </div><br>
    <%
    end if
    %>
<%
  oRS.movenext
  count = count + 1
wend

    if count = d - 1 then
%>
<%
    end if
if count mod 21 <> 20 or count = 20 then
    %>
      <div style = "float:left; width: 250px; height: 300px">
      <a href='buyproducts.asp?c=<%=c+4%>&d=<%=d+4%>'><img src="/graphics/images/more.png"></a>
      </div>
      </div>
    <%
end if

%>

  </div>

<%
    dim username

    username = session("username")
    
    e = request.querystring("e")

    f = request.querystring("f")

    if e = "" then

      e = 1

      f = 4

    end if
    
    ssql = "WITH sellProds AS "

    ssql = ssql & "("
    ssql = ssql & "    SELECT s.id, s.image, s.name, s.username,"
    ssql = ssql & "    ROW_NUMBER() OVER (ORDER BY s.id DESC) AS 'RowNumber'"
    ssql = ssql & "    FROM mustpay a INNER JOIN sellproducts s ON a.itemid = s.id WHERE a.username = '"&username&"'"
    ssql = ssql & ") "
    ssql = ssql & "SELECT * "
    ssql = ssql & "FROM sellProds "
    ssql = ssql & "WHERE RowNumber BETWEEN "&e&" AND "&f&";"

    set oRS = oConnection.Execute(ssql)

    count = 0

    if not oRS.eof then

    %>
<div style="width:900px;float:left;position:relative;left:100px;top:0px">

    <div class="shoptitle" style="float:left">
      <span style="font-size:26">Auctions That You Won, <%=username%></span>
      <hr>
    </div>
  <h1>&nbsp;</h1>
    <%

    end if

    while not oRS.eof

    if count mod 4 = 0 then
    %>
      <div style = "width:900px;float:left">
<%
      if count = 0 and e <> 1 then
%>
      <div style = "float:left; width: 50px; height: 30px">
      <a href='buyproducts.asp?e=<%=e-4%>&f=<%=f-4%>'>less...</a>
      </div>
<%
      end if
    end if
    %>
    <div style = "float:left; width: 250; height: 300;border:1px solid white;">
        <br><a href='buysellproducts.asp?id=<%=oRS("id")%>'><%=oRS("name")%></a>
        <br>Seller: <a href='auction.asp?id=<%=oRS("id")%>'><%=oRS("username")%></a>
        <br>You won this item!
        <a href='buysellproducts.asp?id=<%=oRS("id")%>'><img src='/productitems/<%=oRS("image")%>' width="210" height="210"></a>
    </div>
    <%
    if count = d - 1 then
%>
      <div style = "float:left; width: 250px; height: 230px">
      <a href='buyproducts.asp?e=<%=e+4%>&f=<%=f+4%>'><img src="/graphics/images/more.png"></a>
      </div>
<%
    end if

    if count mod 4 = 3 then
    %>
      </div><br>
</div>
    <%
    end if
    %>
<%
  oRS.movenext
  count = count + 1
wend

if count mod 3 <> 2 then
    %>
      </div>
</div>
    <%
end if

oConnection.close()
%>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>

<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>

<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
<h1>&nbsp;</h1>
    <!-- #include file="inc/footer.inc" -->
