import Principal "mo:base/Principal";
import Result "mo:base/Result";
import VoterModel "./Voter"

module {
    type Vote = VoterModel.Vote;

    public type Project = {
        creator : Principal;
        id : Nat;
        votes : [Vote];
        info : Text; //Replace Text type by ProjectInfo type
    };

    public type SubmitAProject = {
        creator : Principal;
        infos : Text; //Replace Text type by ProjectInfo type
    };

    public type ProjectInfo = {
        description : Text;
        createdAt : Int;
        url : Text;
        // And so on.. so we can configure that later
    };

    public type ProjectResponse = Result.Result<(), {
        #NotAuthorized;
        #Unknown;
    }>;

   

}