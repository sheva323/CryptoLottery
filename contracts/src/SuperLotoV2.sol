// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract SuperLoto {
  event NewBetCreated(
    uint256 indexed gameIndex,
    uint128 indexed durationInDays,
    uint128 newPercentage
  );
  event WinnerSelected(
    uint256 indexed gameIndex,
    address indexed winner,
    address indexed beneficiary,
    uint256 prizeAmount
  );

  struct Lottery {
    uint256 ticketCost;
    uint256 dueDate;
    uint256 balanceBag;
    address[] playerTickets;
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
  //mapping(uint256 => mapping(uint256 => Player)) public gameHistory; //gameIndex => lotteryNumber => player
  mapping(uint256 => mapping(address => address)) public beneficiary; //gameIndex => player  => beneficiary
  mapping(uint256 => Lottery) public lotteries; //gameIndex => lottery info
  mapping(uint256 => Player) public winners; //gameIndex => winner

  constructor() {
    lotteryOwner = msg.sender;
  }

  address public lotteryOwner;
  uint256 public gameIndex;
  uint256 public expensesPercentage;
  uint256 private constant SECONDS_IN_A_DAY = 86400; // 24 * 60 * 60

  function startNewGame(
    uint256 _ticketCost,
    uint128 _expensesPercentage,
    uint128 _gameDurationInDays,
    uint128 _maxPlayers,
    uint128 _minPlayers
  ) external onlyOwner {
    require(!lotteries[gameIndex].isActive, "The game is still in progress");
    require(_expensesPercentage <= 10, "Expenses percentage must be <= 10");
    uint256 _gameDurationInSeconds = _gameDurationInDays * SECONDS_IN_A_DAY;
    address[] memory initPlayers;
    gameIndex++;
    lotteries[gameIndex] = Lottery({
      ticketCost: _ticketCost,
      dueDate: block.timestamp + _gameDurationInSeconds,
      balanceBag: 0,
      playerTickets: initPlayers,
      maxPlayers: _maxPlayers,
      minPlayers: _minPlayers,
      isActive: true,
      isPaid: false
    });
    expensesPercentage = _expensesPercentage;
    emit NewBetCreated(gameIndex, _gameDurationInDays, _expensesPercentage);
  }

  function buyTicket(address _beneficiary) external payable {
    Lottery storage currentLottery = lotteries[gameIndex];
    require(currentLottery.isActive, "The game is not in progress");
    require(
      msg.value % currentLottery.ticketCost == 0,
      "the value sent is not correct "
    );
    uint256 numOfTicketsToBuy = msg.value / currentLottery.ticketCost;

    require(
      numOfTicketsToBuy <=
        (currentLottery.maxPlayers - currentLottery.playerTickets.length),
      "Not enough tickets available."
    );

    require(
      currentLottery.playerTickets.length + numOfTicketsToBuy <=
        currentLottery.maxPlayers,
      "Total players would exceed maxPlayers"
    );

    for (uint256 i = 0; i < numOfTicketsToBuy; i++) {
      lotteries[gameIndex].playerTickets.push(msg.sender);
    }
    lotteries[gameIndex].balanceBag += msg.value;
    beneficiary[gameIndex][msg.sender] = _beneficiary;
  }

  function finishGame() external onlyOwner {
    Lottery storage currentLottery = lotteries[gameIndex];
    require(
      block.timestamp >= currentLottery.dueDate,
      "Game has not finished yet"
    );
    uint256 winningTicket = getPseudoRandom(
      currentLottery.playerTickets.length
    );
    address winnerPlayer = currentLottery.playerTickets[winningTicket];
    require(winnerPlayer != address(0), "Invalid winner address");
    address winnerBeneficiary = beneficiary[gameIndex][winnerPlayer];
    splitPayment(winnerPlayer, winnerBeneficiary, currentLottery.balanceBag);
  }

  function getPseudoRandom(uint256 seed) internal view returns (uint256) {
    require(seed > 0, "No purchased tickets");
    bytes32 blockHash = blockhash(block.number - seed);
    uint256 randomNumber = uint256(
      keccak256(abi.encodePacked(block.timestamp, blockHash))
    );
    uint256 winningTicket = randomNumber % seed;
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
    lotteries[gameIndex].isPaid = true;
    lotteries[gameIndex].isActive = false;
    payable(recipient1).transfer(amountToSend);
    payable(recipient2).transfer(amountToSend);
    winners[gameIndex] = Player({
      playerAddress: recipient1,
      beneficiary: recipient2
    });
  }
}
