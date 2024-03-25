// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }
        }
        return false;
    }

    function determineWinner() external gameStarted onlyOwner {
        // Logic to determine winner and distribute pot
        // For simplicity, assuming winner is player 1
        address winner = players[0];
        payable(winner).transfer(pot);
        emit GameFinished(winner, pot);
    }

    // Other functions like withdrawing funds, etc.
}

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }
        }
        return false;
    }

    function determineWinner() external gameStarted onlyOwner {
        // Logic to determine winner and distribute pot
        // For simplicity, assuming winner is player 1
        address winner = players[0];
        payable(winner).transfer(pot);
        emit GameFinished(winner, pot);
    }

    // Other functions li

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }
        }
        return false;
    }

    function determineWinner() external gameStarted onlyOwner {
        // Logic to determine winner and distribute pot
        // For simplicity, assuming winner is player 1
        address winner = players[0];
        payable(winner).transfer(pot);
        emit GameFinished(winner, pot);

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }
        }
        return false;
    }

    function determineWinner() external gameStarted onlyOwner {
        // Logic to determine winner and distribute pot
        // For simplicity, assuming winner is player 1
        address winner = players[0];
        payable(winner).transfer(pot);
      

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }
        }
        return false;
    }

    function determineWinner() external gameStarted onlyOwner {
        // Logic to determine winner and distribute pot
        // For simplicity, assuming winner is player 1
        address winner = players[0];
        

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }
        }
        return false;
    }

    function determineWinner() external gameStarted onlyOwner {
        // Logic to determine winner and distribute pot
        // For simplicity, assuming winner is player 1
    

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }
        }
        return false;
    }

    function determineWinner() external gameStarted onlyOwner {
        // Logic to determine winner and distribute pot
        // For si

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }
        }
        return false;
    }

    function determineWinner() external gameStarted onlyOwner {
        // Logic to determine

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }
        }
        return false;
    }

    function determineWinner() external gameStarte

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }
        }
        return false;
    }

    f

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {
                return true;
            }

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _card.suit && _hand[i].rank == _card.rank) {

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.length; i++) {
            if (_hand[i].suit == _

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool) {
        for (uint i = 0; i < _hand.lengt

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Card memory _card) private pure returns (bool

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    function cardExists(Card[] memory _hand, Ca

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCard.suit, playedCard.rank);
    }

    fu

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit CardPlayed(msg.sender, playerIdx, playedCa

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        currentTrick.push(playedCard);
        emit C

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add card to current trick
        curren

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't have that card.");

        // Add ca

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[playerIdx], playedCard), "You don't ha

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
        require(cardExists(playerHands[pl

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard = Card(Suit(_suit), Rank(_rank));
    

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card.");
        
        Card memory playedCard 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit < 4 && _rank < 10, "Invalid card."

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any cards.");
        require(_suit

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].length > 0, "You don't have any

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        require(playerHands[playerIdx].le

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = playerIndex[msg.sender];
        re

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer {
        uint playerIdx = pla

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) external gameStarted isValidPlayer

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(uint8 _suit, uint8 _rank) exter

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
    }

    function playCard(u

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloaded(msg.sender, msg.value);
 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.value;
        emit BalanceReloa

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        balances[msg.sender] += msg.v

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg.sender], "You are not a play

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {
        require(isPlayer[msg

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalance() external payable {

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }

    function reloadBalan

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
            emit GameStarted(MAX_PLAYERS);
        }
    }


pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

        if (numPlayers == MIN_PLAYERS) {
           

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
        numPlayers++;

  

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.sender] = msg.value;
   

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayers;
        balances[msg.

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[msg.sender] = numPlayer

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.push(msg.sender);
        playerIndex[ms

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = true;
        players.

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        isPlayer[msg.sender] = t

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante amount.");

        is

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value == ante, "Incorrect ante

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
        require(msg.value

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You are already a player.");
 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!isPlayer[msg.sender], "You 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reached.");
        require(!i

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max number of players reache

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlayers < MAX_PLAYERS, "Max 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {
        require(numPlay

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;
    }

    function joinGame() external payable {

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
        ante = _ante;

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        owner = msg.sender;
 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor(uint _ante) {
        

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
    }

    constructor

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.");
        _;
   

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a player in this game.

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender], "You are not a p

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(isPlayer[msg.sender

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {
        require(i

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
    }

    modifier isValidPlayer() {

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet.");
        _;
  

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game has not started yet

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MAX_PLAYERS, "Game ha

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(numPlayers == MA

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {
        require(

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifier gameStarted() {

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;
    }

    modifie

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started yet.");
        _;

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Game has not started 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
        require(numPlayers > 0, "Ga

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNotStarted() {
    

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier gameNot

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
      

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this funct

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner,

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
        require(msg

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modifier onlyOwner() {
 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uint amount);

    modi

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event BalanceReloaded(address indexed player, uin

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot);
    event Balan

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFinished(address indexed winner, uint pot

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event GameFin

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player, uint indexed playerIndex, Suit s

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address indexed player

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank rank);
    event TrickWon(address

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Suit suit, Rank ra

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed playerIndex, Su

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player, uint indexed

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address indexed player,

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(address inde

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event CardPlayed(

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(uint maxPlayers);
    event

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    event GameStarted(

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTrick;

    even

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] public currentTr

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands;
    Card[] pu

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] public playerHands

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

    Card[][] pub

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank rank;
    }

  

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
        Rank ra

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
        Suit suit;
  

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Card {
       

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caballo, Rey }

    struct Ca

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siete, Sota, Caba

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cinco, Seis, Siet

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, Cuatro, Cin

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As, Dos, Tres, 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum Rank { As,

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos }
    enum

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Espadas, Bastos

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum Suit { Oros, Copas, Esp

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[] public players;

    enum 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex;
    address[

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public playerIndex

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) publ

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;
    mapping(addres

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    mapping(address => bool) public isPlayer;

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    mapping(address => uint) public balances;
    

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 2;
    uint public constant MAX_PLAYERS = 4;
    m

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint public constant MIN_PLAYERS = 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlayers;
    uint publi

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public numPlaye

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint public nu

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;
    uint pub

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint public pot;

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
    uint pub

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public ante;
   

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uint public 

pragma solidity ^0.8.0;

contract ElTute {
    address public owner;
    uin

pragma solidity ^0.8.0;

contract ElTute {
    address pu

pragma solidity ^0.8.0;

contract ElTute {
    

pragma solidity ^0.8.0;

contract ElTut

pragma solidity ^0.8.0;

contra

pragma solidity ^

prag
