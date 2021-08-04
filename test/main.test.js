const {
  constants: { ZERO_ADDRESS }, // Common constants, like the zero address and largest integers
  expectEvent,
  expectRevert
} = require("@openzeppelin/test-helpers");

const Config = artifacts.require("SanwoV1Config");
const Router = artifacts.require("SanwoRouterV1");
const EventPlugin = artifacts.require("SanwoRouterV1PaymentEvent01");

contract("Test for Config and Router", function (addresses) {
  let config, router, eventPlugin;
  const [Alice, Bob] = addresses;

  before(async () => {
    config = await Config.new();
    router = await Router.new(config.address);
    eventPlugin = await EventPlugin.new();
  });

  context("Sanwo Config Test", () => {
    xit("should approve a new plugin and emit approved event", async () => {
      const receipt = await config.approvePlugin(Alice);
      const plugin = await config.approvedPlugins(Alice);
      expect(plugin).to.equal(Alice);
      expectEvent(receipt, "PluginApproved", { pluginAddress: Alice });
    });

    xit("should disapprove plugin and emit disapprove event", async () => {
      const receipt = await config.disapprovePlugin(Alice);
      const plugin = await config.approvedPlugins(Alice);
      expect(plugin).to.equal(ZERO_ADDRESS);
      expectEvent(receipt, "PluginDisapproved", { pluginAddress: Alice });
    });
  });

  context("Sanwo Router Test with Payment Event", async () => {
    let path, amounts, _addresses, plugins;
    before(async () => {
      await config.approvePlugin(eventPlugin.address);
      path = ["0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"];
      _addresses = [Alice, Bob];
      amounts = [10];
      plugins = [eventPlugin.address];
    });

    xit("should revert with wrong payment", async () => {
      await expectRevert(
        router.route(path, amounts, _addresses, plugins, [], {value: 1}),
        'Sanwo: Insufficient ETH amount payed in!'
      );
    });
    it("it should execute event Plugin", async () => {
      expectEvent(
        await router.route(path, amounts, _addresses, plugins, [], {value: 10}),
        "Payment",
        {
          sender: Alice,
          receiver: Bob
        }
      );

    })
  });
});
