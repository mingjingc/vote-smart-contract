const Vote = artifacts.require("Vote");

contract('Vote', (accounts) => {
    it('relyVoter', async () => {
      const vote = await Vote.deployed();
      await vote.relyVoter(accounts[0], {from: accounts[0]}) //第一个帐号部署
      await vote.relyVoter(accounts[1], {from: accounts[0]})

      let can =  await vote.canVote(accounts[1])
      assert.equal(can, true, accounts[1]+" should be a voter")

      await vote.vote(accounts[0], {from: accounts[1]})
      const top10 = await vote.getTop10()
      assert.equal(top10[0], accounts[0], "top10 account 0 should be"+accounts[0]);
    });
});