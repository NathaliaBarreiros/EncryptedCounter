// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "fhevm/lib/TFHE.sol";
import { SepoliaZamaFHEVMConfig } from "fhevm/config/ZamaFHEVMConfig.sol";
import { SepoliaZamaGatewayConfig } from "fhevm/config/ZamaGatewayConfig.sol";
import "fhevm/gateway/GatewayCaller.sol";

/// @title EncryptedCounter3
/// @notice A contract that maintains an encrypted counter and is meant for demonstrating how decryption works
/// @dev Uses TFHE library for fully homomorphic encryption operations and Gateway for decryption
/// @custom:experimental This contract is experimental and uses FHE technology with decryption capabilities

contract EncryptedCounter3 is SepoliaZamaFHEVMConfig, SepoliaZamaGatewayConfig, GatewayCaller {
    /// @dev Decrypted state variable
    euint8 internal counter;
    uint8 public decryptedCounter;

    constructor() {
        // Gateway.setGateway(Gateway.defaultGatewayAddress());
        Gateway.setGateway(0x33347831500F1e73f0ccCBb95c9f86B94d7b1123);

        // Initialize counter with an encrypted zero value
        counter = TFHE.asEuint8(0);
        TFHE.allowThis(counter);
    }

    function incrementBy(einput amount, bytes calldata inputProof) public {
        // Convert input to euint8 and add to counter
        euint8 incrementAmount = TFHE.asEuint8(amount, inputProof);
        counter = TFHE.add(counter, incrementAmount);
        TFHE.allowThis(counter);
    }

    /// @notice Request decryption of the counter value
    function requestDecryptCounter() public {
        // creates a temporary array in memory (not storage) called cts with length 1. We use memory because we only need this array temporarily for the decryption request.

        //uint256[](1) creates a new fixed-size array of type uint256 with length 1. The (1) specifies that we want exactly one element in this array.

        // This syntax is used when creating new arrays in Solidity where:

        // 1. uint256[] declares the array type
        // 2. (1) sets the length
        // 3. So uint256[](1) creates a uint256 array that can hold exactly 1 element at index 0
        uint256[] memory cts = new uint256[](1);

        // converts our encrypted counter (euint8) to a uint256 format that the Gateway can process.
        cts[0] = Gateway.toUint256(counter);

        //sends the request to decrypt with these parameters:
        // 1. cts: array containing our encr1. ypted value
        // 2. this.callbackCounter.selector: specifies which function to call when decryption is complete
        // 3. 0: minimum block delay
        // 4. block.timestamp + 100: deadline for decryption (100 seconds from now)
        // 5. false: indicates not to skip validation
        Gateway.requestDecryption(cts, this.callbackCounter.selector, 0, block.timestamp + 100, false);
    }

    /// @notice Callback function for counter decryption
    /// @param decryptedInput The decrypted counter value
    /// @return The decrypted value
    function callbackCounter(uint256, uint8 decryptedInput) public onlyGateway returns (uint8) {
        decryptedCounter = decryptedInput;
        return decryptedCounter;
    }

    /// @notice Get the decrypted counter value
    /// @return The decrypted counter value
    function getDecryptedCounter() public view returns (uint8) {
        return decryptedCounter;
    }
}
