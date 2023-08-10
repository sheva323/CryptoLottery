// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract SuperLoto {
  event ExpensesPercentageUpdated(uint256 newPercentage);

  struct Lottery {
    uint256 ticketCost;
    uint256 dueDate;
    uint256 playersAmount;
    uint256 balanceBag;
    uint128 maxPlayers;
    uint128 minPlayers;
    bool isActive;
    bool isPaid;
  }
  struct Player {
    address playerAddress;
    address beneficiary;
  }
  modifier onlyOwner() {
    require(msg.sender == lotteryOwner, "Caller is not the lottery owner");
    _;
  }
  mapping(uint256 => mapping(uint256 => Player)) public gameHistory; //gameIndex => lotteryNumber => player
  mapping(uint256 => Lottery) public lotteries; //gameIndex => lottery info
  mapping(uint256 => Player) public winners; //gameIndex => winner

  constructor() {
    lotteryOwner = msg.sender;
  }

  address public lotteryOwner;
  uint256 public gameIndex;
  uint256 public expensesPercentage;
  address[] public currentBeneficiaries;
  uint256 private constant SECONDS_IN_A_DAY = 86400; // 24 * 60 * 60

  function startNewGame(
    uint256 _ticketCost,
    uint256 _playersAmount,
    uint256 _expensesPercentage,
    uint256 _gameDurationInDays,
    address[] memory _beneficiaries,
    uint128 _maxPlayers,
    uint128 _minPlayers
  ) external onlyOwner {
    require(!lotteries[gameIndex].isActive, "The game is still in progress");
    require(_expensesPercentage <= 5, "Expenses percentage must be <= 10");
    require(
      _beneficiaries.length <= 10,
      "Beneficiaries array should not contain more than 10 addresses"
    );
    uint256 _gameDurationInSeconds = _gameDurationInDays * SECONDS_IN_A_DAY;

    gameIndex++;
    lotteries[gameIndex] = Lottery({
      ticketCost: _ticketCost,
      dueDate: block.timestamp + _gameDurationInSeconds,
      playersAmount: _playersAmount,
      balanceBag: 0,
      maxPlayers: _maxPlayers,
      minPlayers: _minPlayers,
      isActive: true,
      isPaid: false
    });
    expensesPercentage = _expensesPercentage;
    currentBeneficiaries = _beneficiaries;
    emit ExpensesPercentageUpdated(_expensesPercentage);
  }

  function buyTicket(uint256 _number, address _beneficiary) external payable {
    Lottery storage currentLottery = lotteries[gameIndex];
    require(currentLottery.isActive, "The game is not in progress");
    require(msg.value == currentLottery.ticketCost, "Incorrect ticket price");
    require(
      gameHistory[gameIndex][_number].playerAddress == address(0),
      "Number already chosen"
    );
    gameHistory[gameIndex][_number].playerAddress = msg.sender;
    gameHistory[gameIndex][_number].beneficiary = _beneficiary;
    currentLottery.balanceBag += msg.value;
  }

  function finishGame() external onlyOwner {
    Lottery storage currentLottery = lotteries[gameIndex];
    require(
      block.timestamp >= currentLottery.dueDate,
      "Game has not finished yet"
    );
    uint256 winnerNumber = getPseudoRandom(
      currentLottery.playersAmount,
      currentLottery.maxPlayers
    );
    address winnerPlayer = gameHistory[gameIndex][winnerNumber].playerAddress;
    if (winnerPlayer != address(0)) {
      address winnerBeneficiary = gameHistory[gameIndex][winnerNumber]
        .beneficiary;
      splitPayment(winnerPlayer, winnerBeneficiary, currentLottery.balanceBag);
    } else {
      address randomBeneficiary = chooseRandomBeneficiary(
        uint256(keccak256(abi.encodePacked(blockhash(block.number - 1))))
      );
      splitPayment(
        randomBeneficiary,
        randomBeneficiary,
        currentLottery.balanceBag
      );
    }
  }

  function getPseudoRandom(
    uint256 seed,
    uint256 range
  ) internal view returns (uint256) {
    require(range > 0, "Range must be greater than zero");
    bytes32 blockHash = blockhash(block.number - seed);
    uint256 randomNumber = uint256(
      keccak256(abi.encodePacked(block.timestamp, blockHash))
    );
    uint256 winningTicket = randomNumber % range;
    return winningTicket;
  }

  function splitPayment(
    address recipient1,
    address recipient2,
    uint256 balanceToSplit
  ) internal {
    require(recipient1 != address(0), "Invalid recipient1 address");
    require(recipient2 != address(0), "Invalid recipient2 address");
    uint256 contractBalance = address(this).balance;
    require(contractBalance >= balanceToSplit, "Insufficient contract balance");

    uint256 expenses = (balanceToSplit * expensesPercentage) / 100;
    uint256 prizeAfterExpenses = balanceToSplit - expenses;
    uint256 amountToSend = prizeAfterExpenses / 2;

    payable(recipient1).transfer(amountToSend);
    payable(recipient2).transfer(amountToSend);
    closeGame();
  }

  function closeGame() internal {
    lotteries[gameIndex].isPaid = true;
    lotteries[gameIndex].isActive = false;
  }

  function chooseRandomBeneficiary(
    uint256 seed
  ) internal view returns (address) {
    require(currentBeneficiaries.length > 0, "No beneficiaries available");
    uint256 beneficiaryIndex = seed % currentBeneficiaries.length;
    return currentBeneficiaries[beneficiaryIndex];
  }
}
