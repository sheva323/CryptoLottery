// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract SuperLoto is VRFConsumerBaseV2, ConfirmedOwner {
  event RequestSent(uint256 requestId, uint32 numWords);
  event RequestFulfilled(uint256 requestId, uint256[] randomWords);

  struct RequestStatus {
    bool fulfilled; // whether the request has been successfully fulfilled
    bool exists; // whether a requestId exists
    uint256[] randomWords;
  }
  struct Lottery {
    uint256 ticketCost;
    bool isActive;
    uint256 dueDate;
  }
  mapping(uint256 => RequestStatus) public s_requests;
  mapping(uint256 => mapping(uint256 => address)) public gameHistory; //game index => (choosen number => player)
  mapping(uint256 => Lottery) public lotteries;

  VRFCoordinatorV2Interface COORDINATOR;

  // Your subscription ID.
  uint64 s_subscriptionId;

  // past requests Id.
  uint256[] public requestIds;
  uint256 public lastRequestId;
  uint256 public gameIndex;

  // The gas lane to use, which specifies the maximum gas price to bump to.
  // For a list of available gas lanes on each network,
  // see https://docs.chain.link/docs/vrf/v2/subscription/supported-networks/#configurations
  //for sepolia is only this one
  bytes32 keyHash =
    0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;

  uint32 callbackGasLimit = 100000;

  // The default is 3, but you can set this higher.
  uint16 requestConfirmations = 3;

  // requested 3 random numbers
  uint32 numWords = 3;

  /**
   * HARDCODED FOR SEPOLIA
   * COORDINATOR: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
   */
  constructor(
    uint64 subscriptionId
  )
    VRFConsumerBaseV2(0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625)
    ConfirmedOwner(msg.sender)
  {
    COORDINATOR = VRFCoordinatorV2Interface(
      0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
    );
    s_subscriptionId = subscriptionId;
  }

  // Assumes the subscription is funded sufficiently.
  function requestRandomWords() external onlyOwner returns (uint256 requestId) {
    // Will revert if subscription is not set and funded.
    requestId = COORDINATOR.requestRandomWords(
      keyHash,
      s_subscriptionId,
      requestConfirmations,
      callbackGasLimit,
      numWords
    );
    s_requests[requestId] = RequestStatus({
      randomWords: new uint256[](0),
      exists: true,
      fulfilled: false
    });
    requestIds.push(requestId);
    lastRequestId = requestId;
    emit RequestSent(requestId, numWords);
    return requestId;
  }

  function fulfillRandomWords(
    uint256 _requestId,
    uint256[] memory _randomWords
  ) internal override {
    require(s_requests[_requestId].exists, "request not found");
    s_requests[_requestId].fulfilled = true;
    s_requests[_requestId].randomWords = _randomWords;
    emit RequestFulfilled(_requestId, _randomWords);
  }

  //only for watching results
  function getRequestStatus(
    uint256 _requestId
  ) external view returns (bool fulfilled, uint256[] memory randomWords) {
    require(s_requests[_requestId].exists, "request not found");
    RequestStatus memory request = s_requests[_requestId];
    return (request.fulfilled, request.randomWords);
  }

  function startNewGame(
    uint256 _ticketCost,
    uint256 _dueDate
  ) external onlyOwner {
    require(!lotteries[gameIndex].isActive, "The game is still in progress");
    gameIndex++;
    lotteries[gameIndex] = Lottery({
      ticketCost: _ticketCost,
      isActive: true,
      dueDate: _dueDate
    });
  }

  function buyTicket(uint256 _number) public payable {
    require(lotteries[gameIndex].isActive, "The game is not in progress");
    require(
      msg.value == lotteries[gameIndex].ticketCost,
      "Incorrect ticket price"
    );
    require(
      gameHistory[gameIndex][_number] == address(0),
      "Number already chosen"
    );
    gameHistory[gameIndex][_number] = msg.sender;
  }
}
