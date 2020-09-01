<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!doctype html>
<html class="no-js" lang="en" dir="ltr">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <base href="/is-us-election-backend/" />
        <title>Election US Backend</title>
        <link rel="icon" type="image/png" href="img/favicon/favicon-32x32.png" sizes="32x32">
        <link rel="icon" type="image/png" href="img/favico/favicon-96x96.png" sizes="96x96">
        <link rel="icon" type="image/png" href="img/favico/favicon-16x16.png" sizes="16x16">
        <link rel="stylesheet" href="css/foundation.css">
        <link rel="stylesheet" href="css/foundation-icons.css" />
        <link rel="stylesheet" href="css/app.css">
        <link rel="stylesheet" href="css/swadl/screen.css">
        <script>

      /** POINT TO YOUR WADL **/

      var xmlDoc = "api/application.wadl";

      /** END CHANGES **/

      var xslDoc = "api-doc/wadl.xsl?"+Math.random();
      var grammarDefs = {};
      function goToWadl(){
        var win = window.open(xmlDoc,'_blank');
        win.focus();
      }
      function loadWadl(){
        xmlDoc = document.getElementById('input_baseUrl').value;
        document.getElementById('example').innerHTML = '';
        document.getElementById('grammars').innerHTML = '';
        document.getElementById('message').innerHTML = '';
        try{
          displayResult();
        }
        catch (e){
          console.log(e);
          document.getElementById('message').innerHTML = "Unable to load wadl. Check cross-domain compatibility.";
        }
      }
      function loadXMLDoc(filename)
      {
        if (window.ActiveXObject)
        {
          xhttp = new ActiveXObject("Msxml2.XMLHTTP");
        }
        else 
        {
          xhttp = new XMLHttpRequest();
        }
        if (xhttp.overrideMimeType){
          xhttp.overrideMimeType('text/xml');
        }
        xhttp.open("GET", filename, false);
        try {xhttp.responseType = "msxml-document"} catch(err) {} // Helping IE11
        xhttp.send("");
        return xhttp.responseXML;
      }

      function foreach(list,callback){
        for (var i=0; i<list.length; i++){
          callback(list[i]);
        }
      }

      function slide(el){
        if (el.style.height == 'auto') el.style.height = el.scrollHeight+'px';
        var height = el.opened ? el.scrollHeight+'px' : '0px';
        if (el.style.height == height){
          endTransition(el);
        }
        else{
          setTimeout(function(){el.style.setProperty("transition","1s");setTimeout(function(){el.style.height=height;},10);},10);
        }
      }

      function slideToggle(el,className,force,callback){
        while (el && (!el.getAttribute('class') || (el.getAttribute('class') && !el.getAttribute('class').match('slideContainer')))){
          el = el.parentNode;
        }
        foreach(el.getElementsByClassName(className),function(el){el.callback = callback; el.opened = (typeof force!='undefined' ? force : !el.opened); slide(el);});
      }

      function endTransition(el){
        el.style.removeProperty("transition");
        if (el.opened){
          setTimeout(function(){el.style.height = "auto";},0);
        }
        if (el.callback){ 
          el.callback();
          el.callback = null;
        }
      }

      function displayResult()
      {
        document.getElementById('input_baseUrl').setAttribute('value',xmlDoc);
        xml = loadXMLDoc(xmlDoc);
        xsl = loadXMLDoc(xslDoc);
        // code for IE
        if (window.ActiveXObject || xhttp.responseType == "msxml-document")
        {
          ex = xml.transformNode(xsl);
          document.getElementById("example").innerHTML = ex;
        }
        // code for Chrome, Firefox, Opera, etc.
        else if (document.implementation && document.implementation.createDocument)
        {
          xsltProcessor = new XSLTProcessor();
          xsltProcessor.importStylesheet(xsl);
          resultDocument = xsltProcessor.transformToFragment(xml, document);
          document.getElementById("example").appendChild(resultDocument);
          foreach(document.getElementsByClassName('grammar'),function(el){addGrammar(el.getAttribute('href'),'xsd.xsl');});
          foreach(document.getElementsByClassName('schema_def'),function(el){
            var target = el.getAttribute('target');
            var content = el.innerHTML;
            foreach(document.getElementsByClassName(target),function(el){
              el.innerHTML += content;
              foreach(el.getElementsByClassName('schema_link'),function(el){el.className+=" active_schema_link";});
            });
          });
          foreach(document.getElementsByClassName('active_schema_link'),function(el){el.onclick=function(){slideToggle(this,'model-signature');}});
          foreach(document.getElementsByClassName('slider'),function(el){
            el.addEventListener('webkitTransitionEnd',function(){endTransition(el);});
            el.addEventListener('transitionend',function(){endTransition(el);});
          });
        }
      }

      function addGrammar(xmlGrammarDoc, xslGrammarDoc)
      {
        var xmlGrammar = loadXMLDoc(xmlGrammarDoc);
        var xslGrammar = loadXMLDoc(xslGrammarDoc);
        // code for IE
        if (window.ActiveXObject || xhttp.responseType == "msxml-document")
        {
          ex = xmlGrammar.transformNode(xslGrammar);
        }
        // code for Chrome, Firefox, Opera, etc.
        else if (document.implementation && document.implementation.createDocument)
        {
          xsltProcessor = new XSLTProcessor();
          xsltProcessor.importStylesheet(xslGrammar);
          resultDocument = xsltProcessor.transformToFragment(xmlGrammar, document);
        }
        document.getElementById('grammars').appendChild(resultDocument);
      }
    </script>
    </head>
    <body onload="displayResult()" id="api-doc">
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
                <form id="api_selector">
          <div class="input">
            <input id="input_baseUrl" name="baseUrl" type="hidden">
          </div>
         
        </form>
                <div id="message" class="error">
                    
                </div>
                <div id="example">
                </div>
                <div id="grammars">
                </div>

            </div>
        </div>



        <script src="js/vendor/jquery.js"></script>
        <script src="js/vendor/what-input.js"></script>
        <script src="js/vendor/foundation.js"></script>
        <script src="js/app.js"></script>
    </body>
</html>