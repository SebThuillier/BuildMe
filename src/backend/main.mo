import Principal "mo:base/Principal";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Error "mo:base/Error";
import Result "mo:base/Result";
import RoundModel "./Models/Round";
import VoterModel "./Models/Voter";
import ProjectModel "./Models/Project";
import Utils "./Helpers/Utils";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

actor {

    //What we want for the first prototype :
    //1) User be able to submit projects :DONE
    //2) User able to vote on those projects (no quadratic voting for now) : DONE

    //3) Make it with rounds : first round all ideas can compete while second round only the five top projects 

    //What do I want the API to looks like for the front end?

    //1) A function submit a project
    //2) A function submit a voter
    //3) A query function to see all projects 
    //4) A query function to see all votes related to one user ? 
    
    // I don't want to integrate my logic for the voting system inside any of the objects 
    // What I mean is that Vote and Projects are separated objects (will be easier to upgrade the prototype to someting more complex)
    
    type Round = RoundModel.Round;
    type Vote = VoterModel.Vote;
    type User = VoterModel.User;
    type VoteResponse = VoterModel.VoteResponse;
    type Project = ProjectModel.Project;
    type ProjectResponse = ProjectModel.ProjectResponse;
    type AddUserResponse = VoterModel.AddUserResponse;
    type SubmitAProject = ProjectModel.SubmitAProject;


    private stable var authorizedUserEntries : [(Principal, User)] = [];
    private var authorizedUsers = HashMap.fromIter<Principal,User>(authorizedUserEntries.vals(), 10, Utils.isEq, Principal.hash);


    stable var projectCount = 0;
    private stable var projectEntries : [(Nat, Project)] = [];
    private var projects = HashMap.fromIter<Nat,Project>(projectEntries.vals(), 10, Nat.equal, Hash.hash);


    private stable var voteCount = 0; 


    system func preupgrade() {
        authorizedUserEntries := Iter.toArray(authorizedUsers.entries());
        projectEntries := Iter.toArray(projects.entries());
    };

    system func postupgrade() {
        authorizedUserEntries := [];
        projectEntries := [];
    };

    public shared(msg) func addUser(user: User) : async AddUserResponse {
        switch (authorizedUsers.get(msg.caller)) {
            case (null) {
                return #err (#NotAuthorized);
            };
            case (?voter) {
                authorizedUsers.put(voter.adress, user);
                return #ok;
            };
        };
        return #err (#Unknown);
        // Iter.toArray(voters.entries()); Do we really need that part ?
    };



    public shared(msg) func addAProject (p : SubmitAProject) : async ProjectResponse {
        //Todo Function to check if the project is correct if it returns true then process.

        switch (authorizedUsers.get(msg.caller)) {
            case (null) {return #err(#NotAuthorized)};
            case (?user) {
                let project : Project = {
                creator = p.creator;
                id = projectCount;
                votes = [];
                info = "";
                };
            projects.put(projectCount, project);
            projectCount +=1;
            return #ok;
            };
        };
        return #err (#Unknown);
    };

    public query func getProjectByIdInsecure(n : Nat) : async ?Project {
        projects.get(n);
    };



    public query func getAllProjectsInsecure() : async [(Nat,Project)] {
        return Iter.toArray(projects.entries());
    };


    

    // public shared func modifyProject (newP : Project) : async ProjectResponse {
    //     //Can only modify the project if it's yours ? 
        
    // }

    public shared(msg) func vote(vote : Vote) : async VoteResponse {
        //We need to check that 
        //1) msg.caller is the user (We don't want someone else to vote for you...)
        //2) user who voted is a voter
        //3) Project id do exist 
        //4) User hasn't already voted for this project
        //5) Then we can process and add this vote in our database

        if (msg.caller != vote.user) {
            return #err (#VotingForSomeoneElse);
        };
        switch (authorizedUsers.get(vote.user)) {
            case (null) {
                return #err (#NotAVoter);
            };
            case (?user) {
                switch (projects.get(vote.project)) {
                    case (null) {
                        return #err (#ProjectNotFound);
                    };
                    case (?project) {
                        if( _hasUserAlreadyVoted(project,vote.user)) {
                            return #err (#AlreadyVoted);
                        };
                        if (vote.number != (-1) and vote.number != 1) {
                            return #err (#VoteNumberNotCorrect);
                        };
                        let newProject : Project = {
                            creator = msg.caller;
                            id = project.id;
                            votes = Array.append<Vote>(project.votes, [vote]);
                            info = project.info;
                        };
                        projects.put(project.id,newProject);
                        voteCount +=1;
                        return #ok;
                    };
                };
                
            };
        };

    };

    func _principalEqual ( x : Principal) : (f : Principal -> Bool) {
        let f = func inside (y : Principal) : Bool {
            return (Principal.equal (x , y))
        };
        return f;
    };
    func _hasUserAlreadyVoted (p : Project, user: Principal) : Bool {
        let votes = p.votes;
        switch (Array.find<Principal>(_votesToUser(votes), _principalEqual(user))) {
            case (null) {
                return false;
            };
            case (?user) {
                return true;
            };
        };
        
    };

    func _voteToUser (vote: Vote) : Principal {
        return (vote.user);
    };

    func _votesToUser (votes : [Vote]) : [Principal] {
       let list = Array.map(votes, _voteToUser);
       return (list);
    };

    let fakeProject : Project = {
        creator = Principal.fromText("gwfpn-foiv7-q6rbx-sfvbl-b54ws-kplbm-vp6vi-xx6f4-hmrpz-snmxp-nae");
        id = 999999999;
        round = 999999999;
        votes = [];
        info = "This is the fake project";
    };


    //TODO : check this function ...
    public shared(msg)func projectVotedOn (user:Principal) : async [(Nat,Nat)] {
        if(msg.caller != user) {
            return [];
        };
            var list = [(0,0)];
            let iter = Iter.range(0,projectCount-1);
            for (x in iter) {
                let projectMaybe : ?Project = projects.get(x);
                let project : Project = Option.get<Project>(projectMaybe, fakeProject); //Ugly ?
                if (project.id == 999999999 and _hasUserAlreadyVoted(project,user)) {
                   list := Array.append<(Nat,Nat)>(list, [(project.id, 2)]);
                };
                if (_hasUserAlreadyVoted(project, user )) {
                    list := Array.append<(Nat,Nat)>(list, [(project.id, 1)]);
                
                } else {
                    list := Array.append<(Nat,Nat)>(list, [(project.id, 0)]);
                };
            };
        return list;
    };

    public shared (msg) func howManyProjectsInsecure () : async Nat {
        return (projectCount);
    };


   
    public func test () : async Project {

        let voteA : Vote = {
            user = Principal.fromText("gwfpn-foiv7-q6rbx-sfvbl-b54ws-kplbm-vp6vi-xx6f4-hmrpz-snmxp-nae");
            number = 10;
            project = 1;
        };

        let voteB : Vote = {
            user = Principal.fromText("nysrp-7nkkq-phfcg-xwzy4-qjxuj-yjofu-6vby4-uioii-aq62a-jjpvz-jae");
            number = 18;
            project = 1;
        };
        
        let project : Project = {
            creator = Principal.fromText("gwfpn-foiv7-q6rbx-sfvbl-b54ws-kplbm-vp6vi-xx6f4-hmrpz-snmxp-nae");
            id = 1;
            round = 10;
            votes = [voteA];
            info = "Abc";
        };

        let newProject : Project = {
            creator = Principal.fromText("gwfpn-foiv7-q6rbx-sfvbl-b54ws-kplbm-vp6vi-xx6f4-hmrpz-snmxp-nae");
            id = project.id;
            votes = Array.append<Vote>(project.votes, [voteB]);
            info = project.info;
        };
        newProject;

    };

    //TODO 
    // Change id in Project (no point of storing it)
    // How to pass a value [] inside a candid type ?
    // change id of project : there is no point letting the user choose (it can even leads to duplicata ids)

    //Big QUESTION : What is better for a type with "variables"
    //Let's imagine we have an type User with some points

    //Solution 1 

    // public type User = {
    //     who : Principal;
    //     name : Text;
    //     var points : Nat;
    // }

    // public type UserShareable = {
    //     who : Principal;
    //     name : Text;
    //     points : Nat;
    // }
    
    //Every time you wanna access some infos on your user you will make a "photo/capture of it and use the Shareable type"

    //Solution 2 

    
    // public type User = {
    //     who : Principal;
    //     name : Text;
    //     points : Nat;
    // }

    //Every time you wanna change the number of points of a user you create a new User object and replace the previous object with the new one?

    let list : [(Nat,Nat)] = [(1,2)];
    let newList = Array.append<(Nat,Nat)>(list, [(2,3)]);
    public func oio () : async [(Nat,Nat)] {
        return (newList);
    };


    //For testing purposes : 

    public func addUserEasy (user : Principal) 
    
};
