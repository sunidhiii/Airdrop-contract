// SPDX-License-Identifier: MIT

// File: @openzeppelin\contracts\math\SafeMath.sol

pragma solidity ^0.6.12;

import "./NFTToken.sol";

pragma solidity ^0.6.12;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

pragma solidity ^0.6.12;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

  /**
   * @dev Implementation of the {IERC721Receiver} interface.
   *
   * Accepts all token transfers.
   * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
   */
contract ERC721Holder is IERC721Receiver {

    /**
     * @dev See {IERC721Receiver-onERC721Received}.
     *
     * Always returns `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}

pragma solidity 0.6.12;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 *
 * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
 * metering changes introduced in the Istanbul hardfork.
 */
contract ReentrancyGuard {
    bool private _notEntered;

    constructor () internal {
        // Storing an initial non-zero value makes deployment a bit more
        // expensive, but in exchange the refund on every call to nonReentrant
        // will be lower in amount. Since refunds are capped to a percetange of
        // the total transaction's gas, it is best to keep them low in cases
        // like this one, to increase the likelihood of the full refund coming
        // into effect.
        _notEntered = true;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}

// File: contracts\MultiSend.sol

pragma solidity 0.6.12;

contract MultiSend is Ownable, ReentrancyGuard, ERC721Holder {

    using SafeMath for uint256;

    NFTToken public nftToken;            // Token purpose
    uint256[] public tokenIdList;        // Multi-token purpose
    address[] public nomineeList;        // List of current nominees

    mapping(address => bool) public whitelisted;            // addresses where funds will be distributed
    // mapping(uint256 => uint256) public tokenBalances;       // balance of each token in smart contract
    mapping (uint256 => bool) public tokenIdExistence;

    constructor(address _nftToken) public {
        nftToken = NFTToken(_nftToken);
    }

    // Load amount in the contract
    function loadToken(uint256 _startId, uint256 _lastId) external onlyOwner {
        
        for(uint i = _startId; i <= _lastId; i++) {
            if(!tokenIdExistence[i]) {
                tokenIdList.push(i);
                tokenIdExistence[i] = true;
            }

            nftToken.safeTransferFrom(msg.sender, address(this), i);                // depositing the token amount in the smart-contract
            // tokenBalances[_tokenId] = tokenBalances[_tokenId].add(_supply);     // update balances
        }
    }
 
    // Unload amount in the contract
    function withdrawToken(uint256 _startId, uint256 _lastId) external onlyOwner nonReentrant {
        for(uint i = _startId; i <= _lastId; i++) {
            require(tokenIdExistence[i], "Withdrawl from non existent token");
            // require(tokenBalances[_tokenId] >= _supply, "Not enough balance");

            nftToken.safeTransferFrom(address(this), msg.sender, i);                // removing the token amount in the smart-contract
            // tokenBalances[_tokenId] = tokenBalances[_tokenId].sub(_supply);
        }
    }

    // airdrop
    function distributeToken(uint256 _startId, uint256 _lastId) external onlyOwner nonReentrant {
        for(uint i = _startId; i <= _lastId; i++) {
            // require(tokenBalances[_tokenId] >= _supply, "The supply is not sufficient");
            require(nomineeList.length == _lastId.sub(_startId).add(1), "Nominee count doesn't match with total tokens to be distributed");

            // tokenBalances[_tokenId] = tokenBalances[_tokenId].sub(_supply);     // update balances
            // uint256 amountPerNominee = _supply.div(nomineeList.length);         // partPerNominee

        // for (uint j=0; j < nomineeList.length; j++) {
            uint j = 0 ;
            _distributeToken(i, nomineeList[j++]);
        }
    }

    function whiteList(address[] calldata _userList) external onlyOwner {
        for (uint256 i = 0; i < _userList.length; i++) {
            if(!whitelisted[_userList[i]]){       // Avoid pushing already whitelisted to array again
                nomineeList.push(_userList[i]);
            }
            whitelisted[_userList[i]] = true;
        }
    }

    function blackList(address[] calldata _userList) external onlyOwner {
        for (uint256 i = 0; i < _userList.length ; i++) {
            (bool isNominee, uint256 s) = _findNomineeIndex(_userList[i]); // Fetch Nominee index in the userList

            if(isNominee) {
                whitelisted[_userList[i]] = false;
                nomineeList[s] = nomineeList[nomineeList.length - 1];
                nomineeList.pop();
            }
        }
    }

    function getNomineeCount() public view returns(uint256) {
        return nomineeList.length;
    }

    function _findNomineeIndex(address _user) private view returns(bool, uint256) {
        for (uint256 s = 0; s < nomineeList.length; s += 1) {
            if (_user == nomineeList[s]) return (true, s);       // Returning with an if to save gas
        }
        return (false, 0);
    }

    // distributeToken perform the transfering of tokens
    function _distributeToken(uint256 _tokenId, address _receiver) private {
        nftToken.safeTransferFrom(address(this), _receiver, _tokenId);
    }
}