<%@ page import="dk.danthrane.twbs.GridSize; dk.danthrane.twbs.InputSize; dk.danthrane.twbs.Icon; dk.danthrane.twbs.ButtonSize; dk.sdu.tekvideo.FaIcon; dk.danthrane.twbs.ButtonStyle" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Ny video til ${course.fullName} (${course.name})</title>
    <meta name="layout" content="main" />
    <asset:javascript src="interact.js" />
</head>

<body>
<twbs:row>
    <twbs:column>
        <twbs:pageHeader><h3>Ny video</h3></twbs:pageHeader>
    </twbs:column>
</twbs:row>
<twbs:row>
    <twbs:column cols="9">
        <div id="wrapper">
            <div id="fields"></div>
            <div id="player" style="width: 800px; height: 600px;"></div>
        </div>
    </twbs:column>
    <twbs:column cols="3">
        <h4>Kontrol panel</h4>
        <twbs:input name="youtubeId" labelText="YouTube Link">
            For eksempel: <code>https://www.youtube.com/watch?v=DXUAyRRkI6k</code> eller <code>DXUAyRRkI6k</code>
        </twbs:input>
        <twbs:button block="true" style="${ButtonStyle.INFO}" id="toggleEdit">
            <fa:icon icon="${FaIcon.EDIT}" /> Start redigering
        </twbs:button>

        <twbs:button block="true" style="${ButtonStyle.LINK}" id="addField">
            <fa:icon icon="${FaIcon.HAND_O_UP}" /> Tilføj nyt felt
        </twbs:button>
    </twbs:column>
</twbs:row>
<hr>
<twbs:row>
    <twbs:column cols="9">

    </twbs:column>
    <twbs:column cols="3">
        <h4><fa:icon icon="${FaIcon.VIDEO_CAMERA}" /> Tidslinie</h4>
        <div id="timeline-subjects"></div>
        <br />
        <twbs:button block="true" style="${ButtonStyle.SUCCESS}" id="addSubject">
            <fa:icon icon="${FaIcon.PLUS}" />
        </twbs:button>
    </twbs:column>
</twbs:row>
<div id="fieldTemplate" class="draggableField hide">
    %{-- TODO Might want to use Bootstrap tooltips instead of titles --}%
    <strong class="field-header">question-1</strong>
    <twbs:button size="${ButtonSize.XS}" title="Rediger svar">
        <twbs:icon icon="${Icon.EDUCATION}" />
    </twbs:button>
    <twbs:button size="${ButtonSize.XS}" title="Skift spørgsmål ID">
        <fa:icon icon="${FaIcon.FONT}" />
    </twbs:button>
    <twbs:button size="${ButtonSize.XS}" style="${ButtonStyle.DANGER}" title="Slet felt">
        <fa:icon icon="${FaIcon.TRASH}" />
    </twbs:button>
    <twbs:button size="${ButtonSize.XS}" style="${ButtonStyle.SUCCESS}" title="Gem ændringer">
        <fa:icon icon="${FaIcon.CHECK}" />
    </twbs:button>
</div>

<div id="questionTemplate" class="hide">
    <twbs:row>
        <twbs:column cols="10" type="${GridSize.SM}">
            <h6>{0} <small>{1}</small></h6>
        </twbs:column>
        <twbs:column cols="2" type="${GridSize.SM}">
            <div class="pull-right admin-subject-margin-fix">
                <twbs:dropdownToggle size="${ButtonSize.XTRA_SMALL}">
                    <twbs:dropdownMenu>
                        <twbs:dropdownItem url="#">
                            <fa:icon icon="${FaIcon.FONT}" />
                            Omdøb
                        </twbs:dropdownItem>
                        <twbs:dropdownItem url="#">
                            <fa:icon icon="${FaIcon.TRASH}" />
                            Slet
                        </twbs:dropdownItem>
                    </twbs:dropdownMenu>
                </twbs:dropdownToggle>
            </div>
        </twbs:column>
    </twbs:row>
</div>

<div id="subjectTemplate" class="hide">
    <div class="admin-timeline-subject" data-id="{2}">
        <twbs:row>
            <twbs:column cols="10" type="${GridSize.SM}">
                <h5>{0} <small>{1}</small></h5>
            </twbs:column>
            <twbs:column cols="2" type="${GridSize.SM}">
                <div class="pull-right admin-subject-margin-fix">
                    <twbs:dropdownToggle size="${ButtonSize.XTRA_SMALL}">
                        <twbs:dropdownMenu>
                            <twbs:dropdownItem url="#">
                                <fa:icon icon="${FaIcon.PLUS}" />
                                Tilføj spørgsmål
                            </twbs:dropdownItem>
                            <twbs:dropdownItem url="#">
                                <fa:icon icon="${FaIcon.FONT}" />
                                Omdøb
                            </twbs:dropdownItem>
                            <twbs:dropdownDivider />
                            <twbs:dropdownItem url="#">
                                <fa:icon icon="${FaIcon.TRASH}" />
                                Slet
                            </twbs:dropdownItem>
                        </twbs:dropdownMenu>
                    </twbs:dropdownToggle>
                </div>
            </twbs:column>
        </twbs:row>
        <div class="admin-time-questions"></div>
    </div>
</div>

<script>
    $(document).ready(function () {
        var player = null;
        var currentTimeline = [];

        function parseYouTubeID(url) {
            if (url.length == 11) {
                return url;
            }
            var regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
            var match = url.match(regExp);
            if (match && match[2].length == 11) {
                return match[2];
            } else {
                return null;
            }
        }

        function formatTimestamp(t) {
            var timestamp = new Date(t);
            return "{0}:{1}".format(
                    timestamp.getMinutes().toString().paddingLeft("00"),
                    timestamp.getSeconds().toString().paddingLeft("00")
            );
        }

        function addSubjectEntry(subject) {
            var rawTemplate = $("#subjectTemplate").html();
            var template = $(rawTemplate.format(
                    subject.title,
                    formatTimestamp(subject.timecode * 1000),
                    42)
            );
            var questions = template.find(".admin-time-questions");
            subject.questions.forEach(function (item) {
                console.log(item);
                questions.append($("#questionTemplate").html().format(
                        item.title,
                        formatTimestamp(item.timecode * 1000))
                );
            });
            $("#timeline-subjects").append(template);
        }

        function displayVideo(youtubeId) {
            if (player !== null) {
                Popcorn.destroy(player);
                $("#player").html("");
            }
            var wrapper = Popcorn.HTMLYouTubeVideoElement("#player");
            wrapper.src = "http://www.youtube.com/watch?v=" + youtubeId + "&controls=0";
            player = Popcorn(wrapper);
        }

        $("#youtubeId").on('change textInput input', function () {
            var id = parseYouTubeID($(this).val());
            if (id !== null) {
                displayVideo(id);
            }
        });

        <g:if test="${params.test}">
        $("#youtubeId").val("eiSfEP7gTRw");
        displayVideo("eiSfEP7gTRw");
        addSubjectEntry({
            title: "Introduktion",
            timecode: 0,
            questions: []
        });

        addSubjectEntry({
            title: "Subtraktion",
            timecode: 140,
            questions: [
                {
                    title: "Subtraktion med tal",
                    timecode: 155, // 2:35 - 5
                    fields: [
                        {
                            name: "secondq",
                            answer: {
                                type: "custom",
                                validator: function (val) {
                                    return (val == 5);
                                }
                            },
                            topoffset: 170,
                            leftoffset: 290
                        }
                    ]
                }
            ]
        });
        </g:if>

        $("#addField").click(function () {
            $("#fields").append("<div class='draggableField'></div>");
        });

        // target elements with the "draggable" class
        interact('.draggableField')
                .draggable({
                    // enable inertial throwing
                    inertia: true,
                    // keep the element within the area of it's parent
                    restrict: {
                        restriction: "parent",
                        endOnly: true,
                        elementRect: { top: 0, left: 0, bottom: 1, right: 1 }
                    },

                    // call this function on every dragmove event
                    onmove: dragMoveListener
                });

        function dragMoveListener (event) {
            var target = event.target;
            var x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
            var y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;

            // translate the element
            target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)';

            // update the posiion attributes
            target.setAttribute('data-x', x);
            target.setAttribute('data-y', y);
        }

    });
</script>
</body>
</html>