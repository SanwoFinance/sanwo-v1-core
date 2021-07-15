const {
  constants: { ZERO_ADDRESS },    // Common constants, like the zero address and largest integers
} = require('@openzeppelin/test-helpers');

const SanwoConfig = artifacts.require("SanwoV1Config");

contract("Test for Config and Router", async (addresses) => {
  
  const sanwoConfig = await SanwoConfig.new()
  
    it("should approve a new plugin", async () => {
      await sanwo.approvePlugin(addresses[0])
      const plugin = await sanwo.approvedPlugins(addresses[0])
      expect(plugin).to.equal(addresses[0])
    })

    it("should disapprove plugin", async () => {
      await sanwo.approvePlugin(addresses[0])
      const plugin = await sanwo.approvedPlugins(addresses[0])
      expect(plugin).to.equal(ZERO_ADDRESS)
    })

})