// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

contract Ownable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Manangeable is Ownable {
    // public mapping, 会自动生成canVote(address) bool 方法
    mapping(address => bool) public canVote;

    function relyVoter(address voter) external onlyOwner {
        canVote[voter] = true;
    }

    function denyVoter(address voter) external onlyOwner {
        canVote[voter] = false;
    }

    modifier onlyVoter() {
        require(canVote[msg.sender], "Manangeable: untrusted voter");
        _;
    }
    modifier candidateOnlyInVoter(address candidate) {
        require(
            canVote[candidate],
            "Manangeable: candidate only in untrusted voters"
        );
        _;
    }
}

contract Vote is Manangeable {
    address[10] public top10;
    mapping(address => uint256) public tally; // counter candidate vote
    mapping(address => address) public voted; // voter has voted

    event VoteLog(address indexed voter, address indexed candidate);

    function vote(address candidate)
        external
        onlyVoter
        candidateOnlyInVoter(candidate)
    {
        if (voted[msg.sender] != address(0)) {
            tally[voted[msg.sender]]--; // 投票数有限，这里省去了溢出检查
        }
        voted[msg.sender] = candidate;
        tally[candidate]++;
        for (uint256 i = 0; i < top10.length; i++) {
            if (tally[top10[i]] < tally[candidate]) {
                top10[i] = candidate;
                break;
            }
        }

        emit VoteLog(msg.sender, candidate);
    }

    function getTop10() external view returns (address[10] memory) {
        return top10;
    }

    function getTally(address candidate) external view returns (uint256) {
        return tally[candidate];
    }
}
