// SPDX-License-Identifier: MIT
pragma solidity >=0.8.30;

/* Compose
 * https://compose.diamonds
 */

/**
 * @title ERC-165 Standard Interface Detection
 * @notice Interface for querying which interfaces a contract supports.
 * @dev See https://eips.ethereum.org/EIPS/eip-165
 */
interface IERC165 {
    /**
     * @notice Query if a contract implements an interface.
     * @param _interfaceId The interface identifier (ERC-165: XOR of all function selectors).
     * @return True if the contract implements _interfaceId, false otherwise.
     */
    function supportsInterface(bytes4 _interfaceId) external view returns (bool);
}
