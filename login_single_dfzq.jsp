<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import ="com.ces.component.archive.service.ADCheckService"%>
<%@ page import="com.donfer.serivce.Encrypt3DES" %>
<%@ page import="com.ces.component.archive.utils.SSOUtil" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
//String username = request.getParameter("username");


String todoid = request.getParameter("todoid") == null ? "" : request.getParameter("todoid");
String modulename = request.getParameter("modulename") == null ? "" :  java.net.URLDecoder.decode(request.getParameter("modulename"),"utf-8");
String unity = request.getParameter("unity") == null ? "" : request.getParameter("unity");

//东方证券单点登录验证功能
String username="";
String moduleId = request.getParameter("moduleId");
String Key=SSOUtil.getProperties("key");
String IV=SSOUtil.getProperties("iv");
String oaUrl = SSOUtil.getProperties("oaUrl");
String SSO = request.getParameter("sso");
String flag = request.getParameter("flag");
String returnRes= "";
if(flag!=null&&flag.equals("0")){
	 try{
		 Encrypt3DES desenc=new Encrypt3DES();
		 String sparams = desenc.decode3DES(SSO,Key,IV);
		 String[] arrtemp = sparams.split("\\|");
		 username = arrtemp[0];
		 System.out.println("+++++++++"+username);
		 returnRes = "success";
	 }catch(Exception ex){
	 	System.out.println(ex.getMessage());
	 }
}else{
	returnRes = "fail";
	System.out.println("登录验证失败!");
}
%>
<!DOCTYPE HTML>
<html style="width: 100%;height: 100%;">
  <head>
    <base href="<%=basePath%>">
    <title>单点登录跳转</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript" src="<%=basePath%>cfg-resource/coral40/cui/dev/js/jquery-1.11.3.js"></script>
	<script type="text/javascript">
		function getCookie(objName) {
		    var arrStr = document.cookie.split("; ");
		    for (var i = 0; i < arrStr.length; i++) {
		        var temp = arrStr[i].split("=");
		        if (temp[0] == objName)
		            return unescape(temp[1]);
		    }
		}
	
		function init() {
		    //delAllCookie();
		     var username =encodeURIComponent("<%=username %>");
		    if (!username) {
		       // username = getCookie("username");
		    }
		    $.ajax({
	            type : "post",
	            url : "<%=path %>/logout",
	            async : false,
	            dataType : "json",
	            success : function(result) {
	            }
	        });
	        
		    if (username) {
		        var params = "username=" + username;
		        $.ajax({
		            type : "post",
		            url : "<%=basePath %>security/sso!ssoPlainText.json",
		            data : params,
		            async : false,
		            dataType : "json",
		            success : function(result) {
		            },
	                error : function () {
	            	window.location.href = '<%=path %>/logout';
	                }
		        });
		    }
				var targetUrl
				var localUrl = window.location.href;
				if (localUrl.indexOf('targetUrl=') > 0) {
				    targetUrl = localUrl.substring(localUrl.indexOf('targetUrl=') + 10);
				}
				if (targetUrl) {
				    window.location.href = '<%=path%>/' + targetUrl;
				} else {
					var todoid = '<%=todoid %>';
					var modulename = '<%=modulename %>';
					var unity = '<%=unity %>';
					if(todoid != ''){
						window.location.href = '<%=path%>/app.jsp?todoid='+todoid;
					}else if(modulename != ''){
						window.location.href = '<%=path%>/app.jsp?modulename='+modulename;
					}else if(unity == '1'){
						window.location.href = '<%=path%>/cfg-resource/coral40/views/component/unity/unity.jsp';
					}else{
						window.location.href = '<%=path%>/app.jsp';
					}
				}
		}
	</script>
  </head>
  <body style="width: 100%;height: 100%;margin: 0px;padding: 0px;overflow: hidden;" scroll="no" onload="init()">
  </body>
</html>
