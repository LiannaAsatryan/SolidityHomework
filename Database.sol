//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Database{

    struct product{
        string productName;
        uint productQuantity;
    }
    struct purchase{
        string name;
        string surname;
        product[] buyedProducts;
    }
    mapping(address => purchase) public database;
    mapping(address => bool) public registered;

    //this function gets two strings(name and surname of the customer) as parameters and stores them in the database
    //when the same customer inputs the name and surname again, the program throws an exception with the appropriate message
    //which means that when the customer register once, his/her personal data is already stored in the database, and if that customer wants to buy
    //something, he/she can only input the products(writing the name and the quantity of that product)
    function writeData(string memory _name, string memory _surname) public {
        require(registered[msg.sender] == false, "Dear customer, You are already registered, it is NOT necessary to fill in name and surname");   
        database[msg.sender].name = _name;
        database[msg.sender].surname = _surname;
        registered[msg.sender] = true;
    }
    //this function gets an array of products, and a product-type item as parameters and checks if the array contains that item.
    //if it contains that item, the function returns a tuple value(true, the index of the item of the array, which is the same as the item given as aparameter)
    //if it does not contain the function returns (false, 0)
    function contains(product[] memory _products, product memory _item) private pure returns(bool, uint){
        for(uint i = 0; i < _products.length; i++) {
            if(keccak256(abi.encodePacked(_products[i].productName)) == keccak256(abi.encodePacked(_item.productName))) {
                return (true, i);
            }
        }
        return (false, 0);
    }
   
   //this function gets an array of products as a parameter and adds them in the database. When the customer buys a product which he has buyed before
   //the number of that product will be changed in the database.
    function writeProducts(product[] memory _products) public{
        for(uint i = 0; i < _products.length; i++) {
            uint index;
            bool contain;
            (contain, index) = contains(database[msg.sender].buyedProducts, _products[i]);
            if(contain) {
                database[msg.sender].buyedProducts[index].productQuantity += _products[i].productQuantity;
            } else{
                database[msg.sender].buyedProducts.push(_products[i]);
            }
        }
    }

    //this is the getter function for the customer's buyed products from the database
    function getBuyedProducts() public view returns(product[] memory) {
        return database[msg.sender].buyedProducts;
    }
}
