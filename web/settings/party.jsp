<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="elect" uri="/WEB-INF/election.tld"%>

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
    </head>
    <body>
        <elect:TopMenuView />
        
        <div class="row">
            <div class="large-8 columns">
                <div class="row">
                    <div class="large-12 columns">
                        <h4>Parties</h4>
                    </div>
                </div>

                <div class="row">
                    <div class="large-12 columns">
                        <elect:ElectionList id="active-elections" path="/api/v1/valg" />
                    </div>
                </div>

            </div>

            <div class="large-4 columns">
                status
            </div>
        </div>



        <script src="js/vendor/jquery.js"></script>
        <script src="js/vendor/what-input.js"></script>
        <script src="js/vendor/foundation.js"></script>
        <script src="js/app.js"></script>
    </body>
</html>
