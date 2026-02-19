// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Diamond} from "../src/Diamond.sol";
import {ERC165Facet} from "../src/facets/ERC165/ERC165Facet.sol";
import {ERC721DataFacet} from "../src/facets/ERC721/ERC721DataFacet.sol";
import {ERC721TransferFacet} from "../src/facets/ERC721/ERC721TransferFacet.sol";
import {DiamondInspectFacet} from "../src/facets/diamond/DiamondInspectFacet.sol";
import {DiamondUpgradeFacet} from "../src/facets/diamond/DiamondUpgradeFacet.sol";

interface IDiamondInspect {
    struct Facet {
        address facet;
        bytes4[] functionSelectors;
    }
    function facets() external view returns (Facet[] memory);
}

contract DeployDiamond is Script {
    Diamond public diamond;
    ERC165Facet public erc165Facet;
    ERC721DataFacet public erc721DataFacet;
    ERC721TransferFacet public erc721TransferFacet;
    DiamondInspectFacet public diamondInspectFacet;
    DiamondUpgradeFacet public diamondUpgradeFacet;

    function setUp() public {}

    /// @notice Entrypoint when no args: reads VERBOSE from env (default false).
    function run() public {
        run(vm.envOr("VERBOSE", false));
    }

    /// @notice Deploy the diamond. Set verbose true to log all facet selectors.
    /// @param verbose If true, log selectors per facet after deployment.
    function run(bool verbose) public {
        address owner = msg.sender;
        if (block.chainid != 31337) {
            owner = vm.envOr("DIAMOND_OWNER", msg.sender);
        }

        vm.startBroadcast();

        // Deploy facets
        erc165Facet = new ERC165Facet();
        erc721DataFacet = new ERC721DataFacet();
        erc721TransferFacet = new ERC721TransferFacet();
        diamondInspectFacet = new DiamondInspectFacet();
        diamondUpgradeFacet = new DiamondUpgradeFacet();

        // Build facet array (order does not affect behavior)
        address[] memory facets = new address[](5);
        facets[0] = address(erc165Facet);
        facets[1] = address(erc721DataFacet);
        facets[2] = address(erc721TransferFacet);
        facets[3] = address(diamondInspectFacet);
        facets[4] = address(diamondUpgradeFacet);

        // Deploy diamond with facets and owner
        diamond = new Diamond(facets, owner);

        vm.stopBroadcast();

        console.log("--------------------------------");
        console.log("Diamond Address:", address(diamond));
        console.log("--------------------------------");
        console.log("Owner:", owner);
        console.log("--------------------------------");

        if (verbose) { 
            console.log("Facets:");
            console.log("ERC165Facet Address:", address(erc165Facet));
            console.log("ERC721DataFacet Address:", address(erc721DataFacet));
            console.log("ERC721TransferFacet Address:", address(erc721TransferFacet));
            console.log("DiamondInspectFacet Address:", address(diamondInspectFacet));
            console.log("DiamondUpgradeFacet Address:", address(diamondUpgradeFacet));
            console.log("--------------------------------");
            _logSelectors();
        }
    }

    /**
     * @notice Returns the name of a facet.
     * @param facet The address of the facet.
     * @return The name of the facet.
     */
    function _facetName(address facet) internal view returns (string memory) {
        if (facet == address(erc165Facet)) return "ERC165Facet";
        if (facet == address(erc721DataFacet)) return "ERC721DataFacet";
        if (facet == address(erc721TransferFacet)) return "ERC721TransferFacet";
        if (facet == address(diamondInspectFacet)) return "DiamondInspectFacet";
        if (facet == address(diamondUpgradeFacet)) return "DiamondUpgradeFacet";
        return "Unknown";
    }

    /**
     * @notice Logs the selectors for each facet.
     */
    function _logSelectors() internal view {
        IDiamondInspect.Facet[] memory facetsAndSelectors = IDiamondInspect(address(diamond)).facets();
        console.log("Selectors per facet:");
        for (uint256 i; i < facetsAndSelectors.length; i++) {
            address facet = facetsAndSelectors[i].facet;
            bytes4[] memory selectors = facetsAndSelectors[i].functionSelectors;
            console.log("");
            console.log(_facetName(facet), "(", selectors.length, "selectors ):");
            for (uint256 j; j < selectors.length; j++) {
                console.log("  ", _selectorHex(selectors[j]));
            }
        }
        console.log("--------------------------------");
    }

    /**
     * @notice Returns the hexadecimal representation of a selector.
     * @param s The selector.
     * @return The hexadecimal representation of the selector.
     */
    function _selectorHex(bytes4 s) internal pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes memory packed = abi.encodePacked(s);
        bytes memory out = new bytes(8);
        for (uint256 i; i < 4; i++) {
            out[i * 2] = hexChars[uint8(packed[i]) >> 4];
            out[i * 2 + 1] = hexChars[uint8(packed[i]) & 0x0f];
        }
        return string(abi.encodePacked("0x", string(out)));
    }
}
