package eduonix.server.security;

import org.apache.amber.oauth2.client.request.OAuthClientRequest;

import javax.net.ssl.*;
import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


/**
 * Created by user on 6/19/15.
 */
public class AuthenticationServlet   extends HttpServlet {


    @Override
    public void init(ServletConfig config) throws ServletException {

        // All the code below is to overcome host name verification failure we get in certificate
        // validation due to self-signed certificate. This code should not be used in a production
        // setup.

        System.out.println("init made it to here");

        try {

            SSLContext sc;

            // Get SSL context
            sc = SSLContext.getInstance("SSL");

            // Create empty HostnameVerifier
            HostnameVerifier hv = new HostnameVerifier() {
                public boolean verify(String urlHostName, SSLSession session) {
                    return true;
                }
            };

            // Create a trust manager that does not validate certificate chains
            TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return null;
                }

                public void checkClientTrusted(java.security.cert.X509Certificate[] certs,
                                               String authType) {
                }

                public void checkServerTrusted(java.security.cert.X509Certificate[] certs,
                                               String authType) {
                }
            } };

            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            //SSLSocketFactory sslSocketFactory = sc.getSocketFactory();

            //HttpsURLConnection.setDefaultSSLSocketFactory(sslSocketFactory);
            SSLContext.setDefault(sc);
            HttpsURLConnection.setDefaultHostnameVerifier(hv);

            // Load init parameters.
//            userName = "admin";
//            password = "admin";
//            serverUrl = "https://localhost:9443/services/";

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }





    @Override
    protected void doGet(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws ServletException,

            IOException {

        System.out.println("doPost made it to here");

        HttpServletRequest request = (HttpServletRequest) servletRequest;

        HttpServletResponse response = (HttpServletResponse) servletResponse;
        HttpSession session = request.getSession();

        String tokenExists = (String)  session.getAttribute(SecureUtils.ACCESS_TOKEN);

        response.setHeader("Cache­control", "no­cache, no­store, must­revalidate");

        if (tokenExists == null) {

            String grantType = SecureUtils.OAUTH2_GRANT_TYPE_CODE ;

            String scope = SecureUtils.SCOPE;

            String callbackurl = SecureUtils.OAUTH_CALLBACK;

            /**

             * A OAuth credential for this application not user.

             */

            String consumerKey = SecureUtils.CONSUMER_KEY;
         //   consumerKey =  Base64.encode(consumerKey.getBytes());

            String authzEndpoint = SecureUtils.OAUTH2_AUTHZ_ENDPOINT;

            String locationURI = null;


            try {

                System.out.println("made it to here trying");
                System.out.println("made it to here trying consumerKey "+consumerKey);
                System.out.println("made it to here trying callbackurl "+callbackurl);
                System.out.println("made it to here trying grantType "+grantType);
                System.out.println("made it to here trying setScope "+scope);

                OAuthClientRequest authzRequest = OAuthClientRequest
                        .authorizationLocation(authzEndpoint)
                        .setClientId(consumerKey)
                        .setRedirectURI(callbackurl)
                        .setResponseType(grantType)
                        .setScope(scope)
                        .buildQueryMessage();
                response.sendRedirect(authzRequest.getLocationUri());

                locationURI = authzRequest.getLocationUri();

                System.out.println("made it to here trying locationURI "+locationURI);


            } catch (Exception e) {

                e.printStackTrace();

                System.out.println("made it to here trying Exception"+e.getLocalizedMessage());

            }







        }

    }


}
