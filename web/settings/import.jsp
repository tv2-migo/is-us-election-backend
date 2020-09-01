<%@page import="java.util.LinkedList"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Map"%>
<%@page import="dk.tv2.election.backend.core.db.entities.Valg"%>
<%@page import="dk.tv2.election.backend.core.model.ImportSource"%>
<%@page import="dk.tv2.election.backend.core.model.ImportType"%>
<%@page import="dk.tv2.election.backend.core.db.entities.Import"%>
<%@page import="dk.tv2.election.backend.managers.EntityManager"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="elect" uri="/WEB-INF/election.tld"%>
<%

    String importId = "0";

    if (request.getParameter("import_id") != null) {
        importId = request.getParameter("import_id");
    }

    if (request.getParameter("action") != null) {
        try {
            int id = Integer.parseInt(importId);
            if (request.getParameter("action").equals("delete") && id > 0) {
                EntityManager.create(Import.class).delete(id);
            }
        } catch (NumberFormatException numberFormatException) {
        }

    }

    String title = importId.equals("0") ? "Create new importer" : "Edit importer";

    if (request.getMethod().equalsIgnoreCase("post")) {

        if (request.getParameter("import-id") != null) {
            try {
                int currentImportId = Integer.parseInt(request.getParameter("import-id"));
                if (currentImportId > 0) {
                    Import importer = EntityManager.create(Import.class).load(currentImportId);
                    importer.setValgId(Integer.parseInt(request.getParameter("import-election-id")));
                    importer.setType(ImportType.valueOf(request.getParameter("import-type")));
                    importer.setName(request.getParameter("import-name"));
                    importer.setImportSource(ImportSource.valueOf(request.getParameter("import-source")));
                    importer.setLocation(request.getParameter("import-location"));
                    importer.setUsername(request.getParameter("import-username"));
                    importer.setPassword(request.getParameter("import-password"));
                    importer.update();
                }

            } catch (NumberFormatException numberFormatException) {
            }

        } else {

            Import importer = EntityManager.create(Import.class);
            importer.setValgId(Integer.parseInt(request.getParameter("import-election-id")));
            importer.setType(ImportType.valueOf(request.getParameter("import-type")));
            importer.setName(request.getParameter("import-name"));
            importer.setImportSource(ImportSource.valueOf(request.getParameter("import-source")));
            importer.setLocation(request.getParameter("import-location"));
            importer.setUsername(request.getParameter("import-username"));
            importer.setPassword(request.getParameter("import-password"));
            importer.create();
        }

        response.sendRedirect("import");
    }

    List<Import> imports = EntityManager.create(Import.class).loadAll();
    List<Valg> valgs = EntityManager.create(Valg.class).allActive();

    Map<String, List<Import>> importConfigurations = new LinkedHashMap<>();

    for (Valg valg : valgs) {
        List<Import> tmp = new LinkedList<>();
        for (Import im : imports) {
            if (im.getValgId() == valg.getId()) {
                tmp.add(im);
            }
        }
        if (tmp.size() > 0) {
            importConfigurations.put(valg.getName(), tmp);
        }
    }

    imports = null;
    valgs = null;

%>
<!doctype html>
<html class="no-js" lang="en" dir="ltr">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <elect:Base />
        <title>Election US Backend</title>
        <link rel="icon" type="image/png" href="img/favicon/favicon-32x32.png" sizes="32x32">
        <link rel="icon" type="image/png" href="img/favico/favicon-96x96.png" sizes="96x96">
        <link rel="icon" type="image/png" href="img/favico/favicon-16x16.png" sizes="16x16">
        <link rel="stylesheet" href="css/foundation.css">
        <link rel="stylesheet" href="css/foundation-icons.css" />
        <link rel="stylesheet" href="css/app.css">

        <script src="js/vendor/jquery.js"></script>
        <script src="js/formvalidator.js"></script>
        <script src="js/vendor/what-input.js"></script>
        <script src="js/vendor/foundation.js"></script>
    </head>
    <body>
        <elect:TopMenuView />

        <div class="row">
            <div class="large-8 columns">
                <div class="row">
                    <div class="large-12 columns">
                        <h4><%=title%></h4>
                    </div>
                </div>

                <div class="row">
                    <div class="large-12 columns">
                        <elect:ImportForm id="<%=importId%>"/>
                    </div>
                </div>

            </div>

            <div class="large-4 columns">
                Imports
                <div class="large-12 columns">
                    <ul class="import-config-overview">
                        <%
                            for (String headline : importConfigurations.keySet()) {
                                out.println("<li>");
                                out.println(headline);
                                out.println("   <ul class=\"import-config-overview-item\">");
                                List<Import> itemImports = importConfigurations.get(headline);
                                for (Import item : itemImports) {
                                    out.println("<li><a href=\"settings/import?import_id=" + item.getId() + "\">");
                                    out.print("<i class=\"fi-");
                                    switch (item.getType()) {
                                        case FOLDER:
                                            out.print("folder");
                                            break;
                                        case FTP:
                                            out.print("laptop");
                                            break;
                                        case URL:
                                            out.print("link");
                                            break;
                                    }
                                    out.print(" medium\">&nbsp;</i> " + item.getImportSource());
                                    out.println("</a></li>");
                                }
                                out.println("   </ul>");
                                out.println("</li>");
                            }
                        %>    
                    </ul>
                </div>
            </div>
        </div>

        <script src="js/app.js"></script>
    </body>
</html>
