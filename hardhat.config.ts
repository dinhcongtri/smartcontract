import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-abi-exporter";
import { Wallet } from "ethers";
import "dotenv/config";

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  abiExporter: {
    path: "./abi",
    runOnCompile: true,
    clear: true,
    flat: true,
    only: [":MerkleDistribution$"],
  },
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
      accounts: [process.env.PRIVATE_KEY! || Wallet.createRandom().privateKey],
    },
  },
};

export default config;
