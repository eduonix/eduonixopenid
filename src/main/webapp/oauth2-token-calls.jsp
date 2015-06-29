<%@page import="org.apache.amber.oauth2.client.response.OAuthClientResponse" %>
<%@page import="org.apache.amber.oauth2.client.URLConnectionClient" %>
<%@page import="org.apache.amber.oauth2.client.OAuthClient" %>
<%@page import="org.apache.amber.oauth2.common.message.types.GrantType" %>
<%@ page import="org.apache.amber.oauth2.client.request.OAuthClientRequest" %>
<%@ page import="eduonix.server.security.SecureUtils" %>

<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLConnection"%>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.net.URLDecoder" %>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    try {

        String consumerKey = (String) session.getAttribute(SecureUtils.CONSUMER_KEY);
        String consumerSecret = (String) session.getAttribute(SecureUtils.CONSUMER_SECRET);
        String tokenEndpoint = (String) session.getAttribute(SecureUtils.OAUTH2_ACCESS_ENDPOINT);
        String code = (String) session.getAttribute(SecureUtils.CODE);
        String callbackurl = (String) session.getAttribute(SecureUtils.OAUTH_CALLBACK);

        OAuthClientRequest accessRequest = OAuthClientRequest.tokenLocation(tokenEndpoint)
                .setGrantType(GrantType.AUTHORIZATION_CODE)
                .setClientId(consumerKey)
                .setClientSecret(consumerSecret)
                .setRedirectURI(callbackurl)
                .setCode(code)
                .buildBodyMessage();

        System.out.println("authorise 3 " + URLDecoder.decode(accessRequest.getBody(), "UTF-8"));

        //create OAuth client that uses custom http client under the hood
        OAuthClient oAuthClient = new OAuthClient(new URLConnectionClient());
        OAuthClientResponse oAuthResponse = oAuthClient.accessToken(accessRequest);

        String accessToken = oAuthResponse.getParam(SecureUtils.ACCESS_TOKEN);


        if (accessToken != null) {
            System.out.println("get-access-token  " + accessToken);
            session.setAttribute(SecureUtils.ACCESS_TOKEN, accessToken);
        }

        String idToken = oAuthResponse.getParam(SecureUtils.ID_TOKEN);

        if (idToken != null) {
            System.out.println("get-id-token  " + idToken);
            session.setAttribute(SecureUtils.ID_TOKEN, idToken);
        }


        String result = executeGet(SecureUtils.USER_INFO_ENDPOINT,  accessToken);

        if(result != null) {
            String json = new String(result);
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(json);
            JSONObject jsonObject = (JSONObject) obj;

            Iterator<?> ite = jsonObject.entrySet().iterator();
%>
            <h3 align="left">OpenID response for id-token request User Info</h3>
            <table  style="width:800px;" class="striped">
<%
            while(ite.hasNext()) {
                Map.Entry entry = (Map.Entry)ite.next();
%>
<tr>
    <td style="width:50%"><%=entry.getKey()%> </td>
    <td><%=entry.getValue()%></td>
</tr>
<%
            }

%>
            </table>
<%

        } else {
                System.out.println("No data received ");
        }



    } catch (Exception e) {
        System.out.println(e.getMessage());
    }
%>



<%!

    public static String executeGet(String targetURL, String accessTokenIdentifier){
        try {
            URL myURL = new URL(targetURL);
            URLConnection myURLConnection = myURL.openConnection();
            myURLConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            myURLConnection.setRequestProperty("Authorization","Bearer " + accessTokenIdentifier);
            myURLConnection.setRequestProperty("Content-Language", "en-US");
            myURLConnection.setUseCaches (false);
            myURLConnection.setDoInput(true);
            myURLConnection.setDoOutput(true);

            System.out.println(myURLConnection.getURL().toExternalForm());

            BufferedReader br = new BufferedReader(
                    new InputStreamReader(myURLConnection.getInputStream()));
            String line;
            StringBuffer response = new StringBuffer();
            while((line = br.readLine()) != null) {
                response.append(line);
                response.append('\r');
            }
            br.close();
            System.out.println(response.toString());
            return response.toString();



        }
        catch (Exception e) {   }
        return "";
    }
%>