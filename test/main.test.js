const {
  constants: { ZERO_ADDRESS }, // Common constants, like the zero address and largest integers
  expectEvent,
} = require("@openzeppelin/test-helpers");

const Config = artifacts.require("SanwoV1Config");
const Router = artifacts.require("SanwoRouterV1");
const PaymentPlugin = artifacts.require("PaymentPlugin");

contract("Test for Config and Router", function (addresses) {
  let config, router, paymentPlugin;
  const Alice = addresses[0];

  before(async () => {
    config = await Config.new();
    router = await Router.new();
    paymentPlugin = await PaymentPlugin.new();
  });

  context("Sanwo Config Test", () => {
    it("should approve a new plugin and emit approved event", async () => {
      const receipt = await config.approvePlugin(Alice);
      const plugin = await config.approvedPlugins(Alice);
      expect(plugin).to.equal(Alice);
      expectEvent(receipt, "PluginApproved", { pluginAddress: Alice });
    });

    it("should disapprove plugin and emit disapprove event", async () => {
      const receipt = await config.disapprovePlugin(Alice);
      const plugin = await config.approvedPlugins(Alice);
      expect(plugin).to.equal(ZERO_ADDRESS);
      expectEvent(receipt, "PluginDisapproved", { pluginAddress: Alice });
    });
  });

  context("Sanwo Router Test with Payment Event", async () => {
    let path, amounts, _addresses, plugins;
    before(() => {
      path = [
        "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE",
        "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE",
      ];
      _addresses = [Alice];
      amounts = [10];
      plugins = [paymentPlugin];
    });

    xit("should revert with wrong payment", async () => {});
  });
});
