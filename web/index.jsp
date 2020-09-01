<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en" dir="ltr">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <base href="/is-us-election-backend/" />
        <title>Election US Backend</title>
        <link rel="icon" type="image/png" href="/img/favicon/favicon-32x32.png" sizes="32x32">
        <link rel="icon" type="image/png" href="/img/favico/favicon-96x96.png" sizes="96x96">
        <link rel="icon" type="image/png" href="/img/favico/favicon-16x16.png" sizes="16x16">
        <link rel="stylesheet" href="css/foundation.css">
        <link rel="stylesheet" href="css/foundation-icons.css" />
        <link rel="stylesheet" href="css/app.css">
    </head>
    <body>
        <div class="title-bar" data-responsive-toggle="main-menu" data-hide-for="medium">
            <button class="menu-icon" type="button" data-toggle></button>
            <div class="title-bar-title">Menu</div>
        </div>

        <div class="top-bar" id="main-menu">
            <div class="top-bar-left">
                <ul class="dropdown menu" data-dropdown-menu>
                    <li class="menu-text">Election-US Backend</li>
                </ul>
            </div>
            <div class="top-bar-right">
                <ul class="menu" data-responsive-menu="drilldown medium-dropdown">
                    <li><a href="/">Home</a></li>
                    <li><a href="status.jsp">Status</a></li> 
                    <li class="has-submenu">
                        <a href="javascript:;">Settings</a>
                        <ul class="submenu menu vertical" data-submenu>
                            <li><a href="settings/election">Election</a></li>
                        </ul>
                    </li>
                    <li><a href="api-doc/">API doc</a></li>
                </ul>
            </div>
        </div>

        <div class="row">
            <div class="large-12 columns">
                <h4>Active elections</h4>
            </div>
        </div>

        <div class="row small-up-1 medium-up-2 large-up-3">
            <h2>Show Active elections</h2>
        </div>

        <div class="row">
            <div class="large-12 columns">
                <h4>Inactive elections</h4>
            </div>
        </div>

        <div class="row small-up-1 medium-up-2 large-up-3">
            <h2>Show Inactive elections</h2>
        </div>



        <script src="js/vendor/jquery.js"></script>
        <script src="js/vendor/what-input.js"></script>
        <script src="js/vendor/foundation.js"></script>
        <script src="js/app.js"></script>
        <script style="javascript">

        </script>
    </body>
</html>
