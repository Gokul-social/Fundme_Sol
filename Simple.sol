// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Simple {  
        //Basic Types : uint,int,address,boolean,bytes

        uint256 myfav;
        uint256[] favns;
        
        struct person 
        {
                uint256 favn;
                string name;
        }
        mapping (string => uint256) public nametofav;

        person public gok = person({favn:33,name:"Gokul"});
        person[] public listofpeople;

        function store(uint256 _myfavno)public{
                myfav= _myfavno;

        }

        function retrieve()public view returns (uint256) {
                return myfav;
        }

        function addPerson(string memory _name,uint256 _favn)public {
                listofpeople.push(person(_favn,_name));
                nametofav[_name]=_favn;
        }
//0xd9145CCE52D386f254917e481eB44e9943F39138

}


