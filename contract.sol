// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttendanceTracker {

    // Struct to represent an attendance record
    struct Attendance {
        bool isPresent;   // Whether the student was present or absent
        uint256 timestamp; // Timestamp when the attendance was recorded
    }

    // Mapping to store attendance records by student address
    mapping(address => mapping(uint256 => Attendance)) public studentAttendance;  // student -> sessionId -> attendance

    // Mapping to store session dates (can be used to map to actual class dates)
    mapping(uint256 => uint256) public sessionDates;  // sessionId -> class date (timestamp)

    // Event to log attendance marking
    event AttendanceMarked(address indexed student, uint256 indexed sessionId, bool isPresent, uint256 timestamp);

    // Function 1: Mark attendance for a student in a specific session
    function markAttendance(address student, uint256 sessionId, bool isPresent) external {
        // Ensure only the instructor (the contract owner) can mark attendance
        require(msg.sender == owner(), "Only the instructor can mark attendance");

        // Record the attendance status
        studentAttendance[student][sessionId] = Attendance({
            isPresent: isPresent,
            timestamp: block.timestamp
        });

        // Emit the event for attendance marking
        emit AttendanceMarked(student, sessionId, isPresent, block.timestamp);
    }

    // Function 2: View attendance record for a specific student
    function viewAttendance(address student, uint256 sessionId) external view returns (bool isPresent, uint256 timestamp) {
        Attendance memory record = studentAttendance[student][sessionId];
        return (record.isPresent, record.timestamp);
    }

    // Dummy owner function to simulate the contract owner (instructor)
    address private _owner;

    constructor() {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }
}
