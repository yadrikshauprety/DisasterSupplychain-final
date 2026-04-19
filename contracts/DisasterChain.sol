// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DisasterChain {
    struct Donation {
        uint256 id;
        address donor;
        string donorName;
        uint256 amount;
        string disasterType;
        string description;
        address ngoWallet;
        uint256 timestamp;
        bool exists;
    }

    struct Shipment {
        uint256 id;
        address ngo;
        string ngoName;
        string description;
        string items;
        string recipientArea;
        string priority;
        uint8 status;
        address logisticsAgent;
        uint256 createdAt;
        bool exists;
    }

    struct Scan {
        uint256 id;
        uint256 shipmentId;
        address agent;
        string agentName;
        string location;
        string gpsCoords;
        uint8 status;
        uint256 timestamp;
    }

    uint256 public nextDonationId = 1;
    uint256 public nextShipmentId = 1;
    uint256 public nextScanId = 1;

    mapping(uint256 => Donation) public donations;
    mapping(uint256 => Shipment) public shipments;
    mapping(uint256 => Scan) public scans;
    
    mapping(uint256 => uint256[]) public shipmentScans;

    event DonationMade(uint256 indexed id, address indexed donor, uint256 amount, string disasterType, uint256 timestamp);
    event ShipmentCreated(uint256 indexed id, address indexed ngo, string description, string recipientArea, uint256 timestamp);
    event PackageScanned(uint256 indexed shipmentId, uint256 indexed scanId, address indexed agent, string location, uint8 status, uint256 timestamp);
    event AidClaimed(uint256 indexed shipmentId, string uid, address indexed recipient, uint256 timestamp);

    function donate(string memory donorName, string memory disasterType, string memory description) public payable {
        require(msg.value > 0, "Donation must be greater than 0");
        
        uint256 id = nextDonationId++;
        donations[id] = Donation(
            id,
            msg.sender,
            donorName,
            msg.value,
            disasterType,
            description,
            address(0), // ngoWallet not specified in input
            block.timestamp,
            true
        );

        emit DonationMade(id, msg.sender, msg.value, disasterType, block.timestamp);
    }

    function createShipment(string memory ngoName, string memory description, string memory items, string memory recipientArea, string memory priority, address logisticsAgent) public returns (uint256) {
        uint256 id = nextShipmentId++;
        
        shipments[id] = Shipment(
            id,
            msg.sender,
            ngoName,
            description,
            items,
            recipientArea,
            priority,
            1, // Created/In Transit status
            logisticsAgent,
            block.timestamp,
            true
        );

        emit ShipmentCreated(id, msg.sender, description, recipientArea, block.timestamp);
        
        return id;
    }

    function recordScan(uint256 shipmentId, string memory agentName, string memory location, string memory gpsCoords, uint8 newStatus) public {
        require(shipments[shipmentId].exists, "Shipment does not exist");
        
        uint256 id = nextScanId++;
        
        scans[id] = Scan(
            id,
            shipmentId,
            msg.sender,
            agentName,
            location,
            gpsCoords,
            newStatus,
            block.timestamp
        );
        
        shipmentScans[shipmentId].push(id);
        shipments[shipmentId].status = newStatus;

        emit PackageScanned(shipmentId, id, msg.sender, location, newStatus, block.timestamp);
    }

    function claimAid(uint256 shipmentId, string memory uid) public {
        require(shipments[shipmentId].exists, "Shipment does not exist");
        require(shipments[shipmentId].status == 5, "Shipment is not delivered yet");
        
        shipments[shipmentId].status = 6; // Status 6 means Claimed
        
        emit AidClaimed(shipmentId, uid, msg.sender, block.timestamp);
    }

    function getAllDonations() public view returns (Donation[] memory) {
        Donation[] memory allDonations = new Donation[](nextDonationId - 1);
        for (uint256 i = 1; i < nextDonationId; i++) {
            allDonations[i - 1] = donations[i];
        }
        return allDonations;
    }

    function getAllShipments() public view returns (Shipment[] memory) {
        Shipment[] memory allShipments = new Shipment[](nextShipmentId - 1);
        for (uint256 i = 1; i < nextShipmentId; i++) {
            allShipments[i - 1] = shipments[i];
        }
        return allShipments;
    }

    function getScansByShipment(uint256 shipmentId) public view returns (uint256[] memory) {
        return shipmentScans[shipmentId];
    }
}
