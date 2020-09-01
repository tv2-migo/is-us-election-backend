<%@page import="dk.tv2.election.us.backend.imports.Importer"%>
<%@page import="java.util.Calendar"%>
<%@page import="dk.tv2.election.us.backend.Publisher"%>
<%@page import="dk.tv2.election.us.backend.core.db.entities.Valg"%>
<%@page import="dk.tv2.election.us.backend.managers.EntityManager"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dk.tv2.election.us.backend.core.model.ValgType"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="elect" uri="/WEB-INF/election.tld"%>
<%
    String electionKey = request.getParameter("__valg");
    String electionPath = electionKey != null ? "/api/v1/valg/" + electionKey : null;

    String title = electionKey != null ? "Edit election" : "Create new election";
    Calendar calendar = Calendar.getInstance();

    if (request.getMethod().equalsIgnoreCase("post")) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

        if (request.getParameter("election-id") != null) {
            try {
                int currentElectionId = Integer.parseInt(request.getParameter("election-id"));
                if (currentElectionId > 0) {
                    Valg election = EntityManager.create(Valg.class).load(currentElectionId);
                    election.setKey(request.getParameter("election-key"));
                    election.setName(request.getParameter("election-name"));
                    election.setType(ValgType.valueOf(request.getParameter("election-type")));
                    election.setCreationDate(dateFormat.parse(request.getParameter("election-date")));

                    calendar.setTime(dateFormat.parse(request.getParameter("election-date")));
                    calendar.add(Calendar.MONTH, 1);

                    election.setExpireDate(calendar.getTime());
                    election.update();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

        } else {
            Valg election = EntityManager.create(Valg.class);
            election.setKey(request.getParameter("election-key"));
            election.setName(request.getParameter("election-name"));
            election.setType(ValgType.valueOf(request.getParameter("election-type")));
            election.setCreationDate(dateFormat.parse(request.getParameter("election-date")));

            calendar.setTime(dateFormat.parse(request.getParameter("election-date")));
            calendar.add(Calendar.MONTH, 1);

            election.setExpireDate(calendar.getTime());
            election.create();
            
            
            Importer importer = new Importer();
            importer.setupValg(election);
            
        }
        Publisher.clearValgCache();
        response.sendRedirect("election");
    }
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
        <link rel="stylesheet" href="css/jquery.datetimepicker.css">
        <link rel="stylesheet" href="css/app.css">

        <script src="js/vendor/jquery.js"></script>
        <script src="js/formvalidator.js"></script>
        <script src="js/jquery.datetimepicker.full.min.js"></script>
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
                        <elect:ElectionForm path="<%=electionPath%>" />
                    </div>
                </div>

            </div>

            <div class="large-4 columns">
                <div class="row">
                    <div class="large-12 columns">
                        <h4>Edit elections</h4>
                        <h6>Active elections</h6>
                    </div>
                </div>

                <div class="row small-up-1 medium-up-2 large-up-3">
                    <elect:ElectionLinkList id="active-elections" path="/api/v1/valg" targetPath="settings/election?__valg=" buttonText="Edit" />
                </div>

                <div class="row">
                    <div class="large-12 columns">
                        <h6>Inactive elections</h6>
                    </div>
                </div>

                <div class="row small-up-1 medium-up-2 large-up-3">
                    <elect:ElectionLinkList id="inactive-elections" path="/api/v1/valg?inactive=true" targetPath="settings/election?__valg=" buttonText="Edit" />
                </div>
            </div>
        </div>

        <script src="js/vendor/what-input.js"></script>
        <script src="js/vendor/foundation.js"></script>
        <script src="js/app.js"></script>


    </body>
</html>
