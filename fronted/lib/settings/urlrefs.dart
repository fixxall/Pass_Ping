var linkref = refUrl();

class refUrl {
  var parser = Uri.http;
  String main = "localhost:3000";
  String userRegister = "api/auth/register";
  String userLogin = "api/auth/login";
  String userCreate = "api/auth/create";
  String userGetdata = "api/auth/getdata";
  String userResetPassword = "api/auth/resetpassword";
  String userChangePassword = "api/auth/changepassword";
  String userEdit = "api/auth/edit";
  String userEditRank = "api/auth/editrank";
  String appGetdata = "api/app/getdata";
  String appCreate = "api/app/create";
  String appDestroy = "api/app/destroy";
  String appEdit = "api/app/edit";
  String vaultGetdata = "api/vault/getdata";
  String vaultCreate = "api/vault/create";
  String vaultDestroy = "api/vault/destroy";
  String vaultEdit = "api/vault/edit";
  String vaultGetFromId = "api/vault/getfromid";
}
