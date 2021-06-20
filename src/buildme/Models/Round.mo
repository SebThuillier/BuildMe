import Principal "mo:base/Principal";
import Model "./Project";

module {

    type Project = Model.Project;

    public type Round = {
        id: Int;
        title:Text;
        description:Text;
        projects: [Project];
        startedAt: Int;
        completedAt: Int;
        isActive: Bool;
    };
}