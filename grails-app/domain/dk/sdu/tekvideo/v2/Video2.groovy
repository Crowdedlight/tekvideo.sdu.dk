package dk.sdu.tekvideo.v2

class Video2 {
    String name
    String youtubeId
    String timelineJson
    String description = "Ingen beskrivelse"
    Boolean videoType = true
    Date dateCreated

    static constraints = {
        name            nullable: false, blank: false
        youtubeId       nullable: false, blank: false
        timelineJson    nullable: true
        description     nullable: true
    }

    static belongsTo = [subject: Subject2]

    static mapping = {
        timelineJson type: "text"
        videoType defaultValue: true
    }

    String getDescription() {
        if (description == null) return "Ingen beskrivelse"
        return description
    }


}