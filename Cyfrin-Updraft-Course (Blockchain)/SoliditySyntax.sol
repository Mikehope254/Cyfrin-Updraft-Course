//SPDX-Licence-Identifier: MIT
pragma solidity 0.8.19; // stating our solidity version
pragma solidity ^0.8.19 //indicates to the compiler to use the version indicated or above
pragma solidity >=0.8.19 <0.9.0 //Stating solidity version within a range 

contract SimpleStorage {
		//My first smart contract
		//Basic Data Types: boolean, uint, int, address, bytes
		
		bool hasFavNum = true;
		uint256 favNum = 88;
		int256 favNum = -88;
		string favNumInText = "eighty-eight";
		address myAddress = 0x6F60af1cd77433f84DFbFD1C0017A66A24f17e10
		bytes32 favBytes32 = "cat"
		
		uint256 favNumber; //not initializing is equal to initializing to zero
		
		//Pure and View keywords
function retrieve() public view returns(uint256) {
    return favoriteNumber;
}

function retrieve() public pure returns(uint256) {
    return 7;
}

//Array of struct
Person[] public list_of_people; // this is a dynamic array. We can add as many Person objects as we like, as the size of the array is not static but can grow and shrink. We can access each Person object in our array by its index.
Person[3] public another_list_of_three_people; // this is a static array. This can only have a maximum of 3
		
}

