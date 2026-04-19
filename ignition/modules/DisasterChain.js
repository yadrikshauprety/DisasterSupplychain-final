import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("DisasterChainModule", (m) => {
  const disasterChain = m.contract("DisasterChain", []);

  return { disasterChain };
});
