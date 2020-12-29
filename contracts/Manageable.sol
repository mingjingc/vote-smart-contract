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
