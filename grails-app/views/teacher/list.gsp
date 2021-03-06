<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>${teacher.user.username}</title>
</head>

<body>

<ol class="breadcrumb">
    <li><g:link uri="/">Hjem</g:link></li>
    <li class="active">${teacher.user.username}</li>
</ol>

<twbs:row>
    <twbs:column>
        <twbs:pageHeader><h3>Info om ${teacher.user.username}</h3></twbs:pageHeader>
        <h5>Aktive fag</h5>
        <g:each in="${courses}" var="course">
            <twbs:row>
                <twbs:column>
                    <sdu:linkToCourse course="${course}">
                        <b>${course.name}</b>
                    </sdu:linkToCourse>
                    <markdown:renderHtml>${course.description}</markdown:renderHtml>
                </twbs:column>
            </twbs:row>
        </g:each>
        <h5>Tidligere fag</h5>
        Ingen.
    </twbs:column>
</twbs:row>

</body>
</html>