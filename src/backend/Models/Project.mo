import Principal "mo:base/Principal";

module {

    public type Project = {
        title: Text;
        description: Text;
        points: Int;
        createdAt: Int;
        startedAt: Int;
        completedAt: Int;
    };
}