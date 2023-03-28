/// @title Vesting Smart Contract
/// @author Karan J Goraniya
/// @dev All function calls are currently implemented without side effects

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Cliffing is Ownable, ReentrancyGuard {
  // Vesting

  uint256 constant Advisor = 5;
  uint256 constant Partnerships = 10;
  uint256 constant Mentors = 9;
  uint256 constant deno = 100;

  // 100000000

  IERC20 private token;
  address private beneficiary;
  uint256 private totalTokens;
  uint256 private start;
  uint256 private cliff;
  uint256 private duration;
  bool public vestingStarted;

  // tokens holder

  uint256 public perAdvisorTokens;
  uint256 public perPartnershipTokens;
  uint256 public perMentorsTokens;

  // tokens holder

  uint256 public totalAdvisors;
  uint256 public totalPartnerships;
  uint256 public totalMentors;

  // start date & end date
  uint startTime;

  enum Roles {
    advisor,
    partnership,
    mentor
  }

  Roles private role;

  struct Beneficiary {
    uint8 role;
    bool isBeneficiary;
    uint256 tokenClaim;
    uint256 lastClaim;
  }

  mapping(address => Beneficiary) beneficiaryMap;

  constructor(address _token) {
    token = IERC20(_token);
  }

  event AddBeneficiary(address beneficiary, uint8 role);

  // @notice It will add beneficiary with specfic role
  // @dev It will check you are not already beneficiary, role should be one of 3 & vesting is started or not.
  // @param _beneficiary, _role will added for users.

  function addBeneficiary(address _beneficiary, uint8 _role) external onlyOwner {
    require(beneficiaryMap[_beneficiary].isBeneficiary == false, "already you are added");
    require(_role < 3, "roles are not available");
    require(vestingStarted == false, "vesting started");
    beneficiaryMap[_beneficiary].role = _role;
    beneficiaryMap[_beneficiary].isBeneficiary = true;

    emit AddBeneficiary(_beneficiary, _role);

    if (_role == 0) {
      totalAdvisors++;
    } else if (_role == 1) {
      totalPartnerships++;
    } else {
      totalMentors++;
    }
  }

  // @notice It will start the vesting by entering cliff period and duration
  // @dev It will check vesting should not started.
  // @param _cliff and _duration will added

  function startVesting(uint256 _cliff, uint256 _duration) external onlyOwner {
    require(vestingStarted == false, "vesting started");
    totalTokens = token.balanceOf(address(this));
    cliff = _cliff;
    duration = _duration;
    vestingStarted = true;
    startTime = block.timestamp;
    tokenCalculate();
  }

  // @notice It will calculate the token for the 3 roles.
  // @dev It will calculate the toke as per above define

  function tokenCalculate() private {
    perAdvisorTokens = ((totalTokens * Advisor) / deno) * totalAdvisors;
    perPartnershipTokens = ((totalTokens * Partnerships) / deno) * totalPartnerships;
    perMentorsTokens = ((totalTokens * Mentors) / deno) * totalMentors;
  }

  // @notice It will trcak the status of the tokens.
  // @dev It will check the role then it will check the timestatus with duration & tokenAvailable for role.
  //  If token available then it will distrubute the token.
  // @return It will return remaining token.

  function tokenStatus() private view returns (uint256) {
    uint8 roleCheck = beneficiaryMap[msg.sender].role;
    uint256 tokenAvailable;
    uint256 claimTokens = beneficiaryMap[msg.sender].tokenClaim;

    uint256 timeStatus = block.timestamp - startTime - cliff;

    if (roleCheck == 0) {
      if (timeStatus >= duration) {
        tokenAvailable = perAdvisorTokens;
      } else {
        tokenAvailable = (perAdvisorTokens * timeStatus) / duration;
      }
    } else if (roleCheck == 1) {
      if (timeStatus >= duration) {
        tokenAvailable = perPartnershipTokens;
      } else {
        tokenAvailable = (perPartnershipTokens * timeStatus) / duration;
      }
    } else {
      if (timeStatus >= duration) {
        tokenAvailable = perMentorsTokens;
      } else {
        tokenAvailable = (perMentorsTokens * timeStatus) / duration;
      }
    }
    return tokenAvailable - claimTokens;
  }

  // @notice User's will able to claim token
  // @dev It will check all the claimtoken and condition.It  also check whether you claim token last month or not.
  // If yes then youwill not able cliam the token.

  function claimToken() external nonReentrant {
    require(vestingStarted == true, "vesting not strated");
    require(beneficiaryMap[msg.sender].isBeneficiary == true, "You are not beneficiary");
    require(block.timestamp >= cliff + startTime, "vesting is in cliff period");
    require(
      block.timestamp - beneficiaryMap[msg.sender].lastClaim > 2629743,
      "already claim within last month"
    );
    uint8 roleCheck = beneficiaryMap[msg.sender].role;
    uint256 claimedToken = beneficiaryMap[msg.sender].tokenClaim;

    if (roleCheck == 0) {
      require(claimedToken < perAdvisorTokens, "you have claim all Tokens");
    } else if (roleCheck == 1) {
      require(claimedToken < perPartnershipTokens, "you have claim all Tokens");
    } else {
      require(claimedToken < perMentorsTokens, "you have claim all Tokens");
    }
    uint256 tokens = tokenStatus();

    token.transfer(msg.sender, tokens);
    beneficiaryMap[msg.sender].lastClaim = block.timestamp;
    beneficiaryMap[msg.sender].tokenClaim += tokens;
  }
}
