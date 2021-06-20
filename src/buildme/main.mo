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

    public func addVoter(voter: Voter) : async () {

    };

    public func removeVoter() : async () {

    };

    public func vote() : async () {

    };

    public func startRound() : async () {

    };

    public func endRound() : async () {

    };

    public func getRoundById() : async () {

    };

    public func getRounds() : async () {

    };

};
