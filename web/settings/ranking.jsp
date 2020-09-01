<%@page import="java.util.Collections"%>
<%@page import="dk.tv2.election.backend.core.db.entities.Kandidat"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedList"%>
<%@page import="dk.tv2.election.backend.core.db.entities.Storkreds"%>
<%@page import="java.util.List"%>
<%@page import="dk.tv2.election.backend.managers.EntityManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="elect" uri="/WEB-INF/election.tld"%>
<%

    if (request.getMethod().equalsIgnoreCase("post")) {

        List<Storkreds> storKreds = EntityManager.create(Storkreds.class).loadAll();
        Map<Integer, List> rankingMap = new LinkedHashMap<>();

        for (Storkreds kreds : storKreds) {
            rankingMap.put(kreds.getId(), new LinkedList<>());
        }

        String[] order = request.getParameter("rankingOrder").split(",");
        if (order != null) {
            for (int index = 0; index < order.length; index++) {
                String orderItem = order[index];
                if (orderItem.contains(":")) {
                    String[] kredsAndKandidate = orderItem.split(":");
                    if (kredsAndKandidate.length == 2) {
                        int kredsId = Integer.parseInt(kredsAndKandidate[0]);
                        int candidateId = Integer.parseInt(kredsAndKandidate[1]);
                        List<Integer> kandidateList = rankingMap.get(kredsId);
                        kandidateList.add(candidateId);
                        rankingMap.put(kredsId, kandidateList);
                    }
                }
            }

            boolean firstUpdate = true;

            for (Storkreds kreds : storKreds) {
                List<Integer> kandidateRanking = rankingMap.get(kreds.getId());
                Collections.reverse(kandidateRanking);
                for (int index = 0; index < kandidateRanking.size(); index++) {
                    int kandidatId = kandidateRanking.get(index);
                    Kandidat kandidat = EntityManager.create(Kandidat.class).load(kandidatId);

                    if (firstUpdate) {
                        kandidat.clearRanking(kandidat.getValgId());
                        firstUpdate = false;
                    }

                    kandidat.updateRanking(index + 1);
                }
            }

        }

        response.sendRedirect(request.getContextPath() + "/settings/ranking");
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
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.0/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="css/app.css">

    </head>
    <body>
        <elect:TopMenuView />

        <div class="row" style="max-width: 90rem;">
            <div class="large-12 columns">
                <div class="row">
                    <div class="large-12 columns">
                        <h4>Ranking</h4>
                    </div>
                </div>

                <div class="row">
                    <div class="large-6 columns">
                        <elect:ElectionList id="active-elections" path="/api/v1/valg" />
                    </div>
                </div>
                <div class="row">
                    <div class="large-6 columns">
                        <form id="targetRanking">
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>&nbsp;</td>
                                    <td width="110"><strong>Enter name</strong><td>
                                    <td width="300"><input id="candidatesElements" style="width:300px;"/>
                                    <td style="padding-top:20px;" align="center" valign="middle" width="25"><input type="submit" id="form-add" class="button" value="Add" /></td>
                                    <td>&nbsp;</td>
                                </tr>
                            </table><br/>
                            <div id="ranking-list"></div>                                         
                        </form>
                    </div>
                </div>

                <p>&nbsp;</p>   
                <form id="rankingRoles" action="settings/ranking" method="POST">
                    <input name="rankingOrder" id="rankingOrder" type="hidden" value="" />
                    <div class="row">
                        <div class="large-12 columns">
                            <elect:RakingView id="storkreds-list" path="/api/v1/valg" />
                        </div>
                        <p>&nbsp;</p>
                        <div class="medium-6 columns text-right">    
                            <input type="submit" id="form-save" class="button" value="Save" />
                        </div>
                    </div>
                </form>

            </div>



        </div>


        <script src="js/vendor/jquery.js"></script>
        <script src="https://code.jquery.com/ui/1.12.0/jquery-ui.js"></script>
        <script src="js/vendor/what-input.js"></script>
        <script src="js/vendor/foundation.js"></script>
        <script src="js/app.js"></script>
        <elect:RakingJavaScript id="raking-list-ids" path="/api/v1/valg" />
    </body>
</html>
