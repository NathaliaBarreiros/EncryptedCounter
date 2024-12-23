// import { ethers } from "hardhat";
// async function main() {
//   const EncryptedCounter1 = await ethers.getContractFactory("EncryptedCounter1");
//   const counter = await EncryptedCounter1.deploy();
//   await counter.waitForDeployment();
//   const counterAddress = await counter.getAddress();
//   console.log(`EncryptedCounter1 deployed to ${counterAddress}`);
// }
// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy("EncryptedCounter1", {
    from: deployer,
    args: [],
    log: true,
  });
};

export default func;
func.tags = ["EncryptedCounter1"];
