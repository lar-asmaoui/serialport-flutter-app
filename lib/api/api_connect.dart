// ignore_for_file: constant_identifier_names

class ApiConnect {
  static const HOST_PATH = "http://127.0.0.1/mathana";
  //users
  static const create = "$HOST_PATH/users/create.php";
  static const login = "$HOST_PATH/users/login.php";
  static const validate = "$HOST_PATH/users/validate.php";
  static const loadUsers = "$HOST_PATH/users/all.php";
  static const updateUser = "$HOST_PATH/users/update.php";
  static const deleteUser = "$HOST_PATH/users/delete.php";
  static const updateAllInfo = "$HOST_PATH/users/update_all_info.php";

  // orders
  static const addOrder = "$HOST_PATH/orders/add.php";
  static const loadOrders = "$HOST_PATH/orders/read.php";

  // prices
  static const getPrices = "$HOST_PATH/prices/read.php";
  static const updatePrice = "$HOST_PATH/prices/update.php";
}
