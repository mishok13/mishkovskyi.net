<%inherit file="base.mako" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="description" content="Andrii Mishkovskyi's personal page" />
    ${self.head()}
  </head>
  <body>
    <div id="content">
      ${next.body()}
    </div> <!-- End Content -->
    <div id="footer">
      ${self.footer()}
    </div> <!-- End Footer -->
  </body>
</html>
<%def name="head()">
  <%include file="head-index.mako" />
</%def>
<%def name="footer()">
  <%include file="footer-index.mako" />
</%def>
