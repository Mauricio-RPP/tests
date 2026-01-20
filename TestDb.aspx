
<%@ Page Language="C#" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>SQL Connectivity Test</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
</head>
<body style="font-family: Consolas, Menlo, 'Segoe UI', Arial; margin:24px">
<%
    // Read connection string named "SqlTestConn" from web.config
    var cs = ConfigurationManager.ConnectionStrings["SqlTestConn"];
    if (cs == null || String.IsNullOrWhiteSpace(cs.ConnectionString))
    {
        Response.Write("<h1>Configuration Error</h1>");
        Response.Write("<p>Connection string 'SqlTestConn' not found or empty in web.config.</p>");
        Response.End();
    }

    // Default test query (you can change this)
    string sql = "select id, name from dba.dbo.Table_Test;";

    try
    {
        using (var conn = new SqlConnection(cs.ConnectionString))
        {
            conn.Open();
            using (var cmd = new SqlCommand(sql, conn))
            using (var rdr = cmd.ExecuteReader())
            {
                Response.Write("<h1>Connected & query executed</h1>");
                Response.Write("<p>Connection string name: <code>SqlTestConn</code></p>");
                Response.Write("<table border='1' cellspacing='0' cellpadding='4'><tr>");
                for (int i = 0; i < rdr.FieldCount; i++)
                {
                    Response.Write("<th>" + Server.HtmlEncode(rdr.GetName(i)) + "</th>");
                }
                Response.Write("</tr>");
                while (rdr.Read())
                {
                    Response.Write("<tr>");
                    for (int i = 0; i < rdr.FieldCount; i++)
                    {
                        string v = rdr.IsDBNull(i) ? "" : Convert.ToString(rdr.GetValue(i));
                        Response.Write("<td>" + Server.HtmlEncode(v) + "</td>");
                    }
                    Response.Write("</tr>");
                }
                Response.Write("</table>");
            }
        }
    }
    catch (Exception ex)
    {
        Response.Write("<h1>Error</h1>");
        Response.Write("<pre style='white-space:pre-wrap'>" + Server.HtmlEncode(ex.ToString()) + "</pre>");
    }
%>
</body>
</html>