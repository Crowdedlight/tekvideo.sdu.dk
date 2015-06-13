package dk.sdu.tekvideo

import static dk.sdu.tekvideo.TagLibUtils.fail

/**
 * @author Dan Thrane
 */
class SemesterTagLib {
    static namespace = "sdu"

    def semesterString = { attrs, body ->
        Semester semester = attrs.remove("semester") ?: fail("semester", "sdu:semesterString")
        out << ((semester.spring) ? "For�r" : "Efter�r")
        out << " "
        out << semester.year
    }
}
