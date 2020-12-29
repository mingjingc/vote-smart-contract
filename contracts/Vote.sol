// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;
import "./Manageable.sol";

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
