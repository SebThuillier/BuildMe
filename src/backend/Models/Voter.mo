import Principal "mo:base/Principal";
import Result "mo:base/Result";

module {

    public type User = {
        adress : Principal;
        username: Text;
        points: Int; //Number of points the user can currently spend to vote
        infos : UserInfo;
    };

    public type UserInfo = {
        bio : Text;
        age : Nat;
        twitter : Text;
        github : Text;
        //We can configure later
    };


    public type Vote = {
        user : Principal;
        number : Int;   //Number of vote the user wants to give to a project for the moment vote Against : -1 / voteFor : 1;
        project : Nat; //Project the user is voting for
    };

    public type VoteResponse = Result.Result<(), {
        #AlreadyVoted;
        #NotAVoter;
        #VotingForSomeoneElse;
        #RoundNotFound;
        #NotEnoughPoints;
        #VoteNumberNotCorrect;
        #ProjectNotFound
    }>;

     public type AddUserResponse = Result.Result<(), {
        #NotAuthorized;
        #Unknown;
    }>
}