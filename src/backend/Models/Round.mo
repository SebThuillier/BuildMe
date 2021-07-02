import Principal "mo:base/Principal";
import Model "./Project";

module {

    type Project = Model.Project;

    public type Round = {
        id: Nat;
        title:Text;
        description:Text;
        projects: [Project];
        startedAt: Int;
        completedAt: Int;
        isActive: Bool;
    };
}