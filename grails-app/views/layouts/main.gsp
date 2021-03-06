<%@ page import="grails.plugin.springsecurity.SpringSecurityUtils; dk.danthrane.twbs.ButtonStyle; dk.sdu.tekvideo.FaIcon" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>TekVideo | <g:layoutTitle default="Title"/></title>
    <g:layoutHead/>
    <asset:stylesheet src="application.css"/>
    <asset:javascript src="application.js"/>
    <fa:require />
    <link rel="shortcut icon" href="${asset.assetPath(src: "favicon.ico")}" />

    <script>
        $(function() {
            var start = Date.now();
            events.configure("${createLink(controller: "event", action: "register")}");
            events.start();

            events.emit({
                "kind": "VISIT_SITE",
                "url": document.location.href,
                "ua": navigator.userAgent
            }, true);

            window.onbeforeunload = function() {
                events.emit({
                    "kind": "EXIT_SITE",
                    "url": document.location.href,
                    "ua": navigator.userAgent,
                    "time": Date.now() - start
                });
                events.flush(false);
            };
        });
    </script>
</head>
<body>

<twbs:navbar>
    <g:content key="navbar-brand">
        <asset:image src="sdu_branch.png" class="navbar-logo"/>
        Video
    </g:content>
    <twbs:navbarLinks>
        <twbs:navbarLink action="list" controller="course">Kurser</twbs:navbarLink>

        <sec:ifAllGranted roles="ROLE_TEACHER">
            <twbs:navbarLink controller="courseManagement">Kursusadministration</twbs:navbarLink>
            <twbs:navbarLink controller="accountManagement" action="manage">Kontoadministration</twbs:navbarLink>
            <twbs:navbarLink controller="stats">Statistikker</twbs:navbarLink>
        </sec:ifAllGranted>
    </twbs:navbarLinks>
    <twbs:navbarPullRight>
        <twbs:navbarLinks>
            <sec:ifNotLoggedIn>
                <twbs:navDropdownToggle>
                    Log ind

                    <twbs:dropdownMenu>
                        <li class="inline-login">
                            <twbs:row>
                                <twbs:column>
                                    <i>Ved hjælp af:</i> <br/>
                                    <twbs:linkButton controller="sso" action="index" style="${ButtonStyle.DEFAULT}"
                                                     block="true">
                                        <asset:image src="sdu_branch.png" class="sdu-logo-button"/> SDU SSO
                                    </twbs:linkButton>
                                </twbs:column>
                            </twbs:row>
                            <twbs:row>
                                <twbs:column>
                                    <i>Eller med en TekVideo bruger</i>
                                %{--
                                    Is it pretty to lookup configuration in a view? Definitely not.
                                    Is it better than the alternative? Yes.
                                --}%
                                    <twbs:form action="${createLink(uri: SpringSecurityUtils.securityConfig.apf.filterProcessesUrl)}"
                                               method="POST" id="loginForm" name="loginForm" autocomplete="off">
                                        <twbs:input name="username" labelText="Brugernavn" />
                                        <twbs:input name="password" type="password" labelText="Kodeord" />
                                        <twbs:checkbox name="rememberMeParameter" id="remember_me" labelText="Forbliv logget ind" />

                                        <twbs:button type="submit" style="${ButtonStyle.PRIMARY}" block="true">
                                            Log ind
                                        </twbs:button>

                                        <twbs:row>
                                            <twbs:column md="6">
                                                <twbs:linkButton controller="register" action="forgotPassword" style="${ButtonStyle.LINK}" block="true">
                                                    Glemt kodeord?
                                                </twbs:linkButton>
                                            </twbs:column>
                                            <twbs:column md="6">
                                                <twbs:linkButton elementId="register" controller="register" style="${ButtonStyle.LINK}" block="true">
                                                    Ny bruger?
                                                </twbs:linkButton>
                                            </twbs:column>
                                        </twbs:row>
                                    </twbs:form>
                                </twbs:column>
                            </twbs:row>
                        </li>
                    </twbs:dropdownMenu>
                </twbs:navDropdownToggle>
            </sec:ifNotLoggedIn>
            <sec:ifLoggedIn>
                <twbs:navDropdownToggle>
                    <sdu:username/>
                    <twbs:dropdownMenu>
                        <twbs:dropdownItem controller="AccountManagement" action="index">
                            <fa:icon icon="${FaIcon.WRENCH}"/>
                            Konto indstillinger
                        </twbs:dropdownItem>
                        <twbs:dropdownDivider/>
                        <twbs:dropdownItem method="POST" controller="logout" action="">Log ud</twbs:dropdownItem>
                    </twbs:dropdownMenu>
                </twbs:navDropdownToggle>
            </sec:ifLoggedIn>
        </twbs:navbarLinks>
    </twbs:navbarPullRight>
</twbs:navbar>

<twbs:container>
    <g:if test="${flash.error}">
        <twbs:alert type="danger">${flash.error}</twbs:alert>
    </g:if>
    <g:if test="${flash.warning}">
        <twbs:alert type="warning">${flash.warning}</twbs:alert>
    </g:if>
    <g:if test="${flash.success}">
        <twbs:alert type="success">${flash.success}</twbs:alert>
    </g:if>
    <g:if test="${flash.message}">
        <twbs:alert type="info">${flash.message}</twbs:alert>
    </g:if>
    <g:layoutBody/>
</twbs:container>

<twbs:container id="footer">
    <twbs:row>
        <twbs:column cols="3">
        </twbs:column>
        <twbs:column cols="3">
        </twbs:column>
        <twbs:column cols="6">
            <div class="pull-right">
                <asset:image src="sdu_logo.png" />
            </div>
        </twbs:column>
    </twbs:row>
</twbs:container>
</body>
</html>