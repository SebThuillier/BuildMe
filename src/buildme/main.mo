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
import Utils "./Helpers/Utils";

actor {

    type Round = RoundModel.Round;
    type Voter = VoterModel.Voter;

    type ErrorHandler = { #message : Text;};

    private stable var id: Int = 0;
    
    private stable var voterEntries : [(Principal, Voter)] = [];
    private var voters = HashMap.fromIter<Principal,Voter>(voterEntries.vals(), 10, Utils.isEq, Principal.hash);

    private stable var roundEntries : [(Int, Round)] = [];
    private var rounds = HashMap.fromIter<Int,Round>(roundEntries.vals(), 10, Int.equal, Int.hash);

    system func preupgrade() {
        voterEntries := Iter.toArray(voters.entries());
        roundEntries := Iter.toArray(rounds.entries());
    };

    system func postupgrade() {
        voterEntries := [];
        roundEntries := [];
    };

    public shared(msg) func addVoter(voter: Voter) : async [(Principal, Voter)] {
        voters.put(msg.caller,voter);
        Iter.toArray(voters.entries());
    };

    public shared(msg) func removeVoter() : async () {
        voters.delete(msg.caller);
    };

    public shared(msg) func getVoter(principal: Principal) : async ?Voter {
        voters.get(principal);
    };

    public shared(msg) func getVoters() : async [(Principal, Voter)] {
        Iter.toArray(voters.entries());
    };

    public shared(msg) func vote() : async () {

    };

    public shared(msg) func startRound() : async () {

    };

    public shared(msg) func endRound() : async () {

    };

    public shared(msg) func getRoundById() : async () {

    };

    public shared(msg) func getRounds() : async () {

    };

};
