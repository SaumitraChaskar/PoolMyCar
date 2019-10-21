class UserAccount{
  String username;
  String email;
  String contactNo;
  String carRegeNo;
  String licenseNo;
  bool isCarOwner;


  UserAccount(String username, String email, String contactNo, {this.carRegeNo,this.licenseNo}){
    this.username = username;
    this.email = email;
    this.contactNo = contactNo;
    
    if(carRegeNo != null && licenseNo != null){
      this.carRegeNo = carRegeNo;
      this.licenseNo = licenseNo;

      this.isCarOwner = true;
    } else{
      this.isCarOwner = false;
    }
  }
}