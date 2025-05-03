<%
    System.out.println("Logout: Invalidating session");
    session.invalidate();
    System.out.println("Logout: Redirecting to login page");
    response.sendRedirect("login.html");
%> 