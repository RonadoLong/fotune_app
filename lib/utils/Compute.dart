import 'package:date_format/date_format.dart';
import 'package:fotune_app/page/stock/model/Stock.dart';
import 'package:fotune_app/page/stock/model/StockIndex.dart';

/**
 * 计算涨跌幅率
 * @parm yesterday_close 昨收价
 * @parm current_prices 当前价格
 * @parm today_open 今日开盘价
 */
double ComputeGainsRate(
    double yesterday_close, double current_prices, double today_open) {
  double result;
  if (current_prices == 0) {
    result = 0.0;
  } else {
    if (yesterday_close != 0) {
      result = (current_prices - yesterday_close) / yesterday_close;
    } else {
      if (today_open != 0) {
        result = (current_prices - today_open) / today_open;
      } else {
        result = 0.0;
      }
    }
  }
  return result;
}

/**
 * 计算涨跌幅
 * @parm yesterday_close 昨收价
 * @parm current_prices 当前价格
 * @parm today_open 今日开盘价
 */
String ComputeGainsNum(
    double yesterday_close, double current_prices, double today_open) {
  String gains_num;
  if (current_prices == 0) {
    gains_num = "0.00";
  } else {
    if (yesterday_close != 0) {
      gains_num = (current_prices - yesterday_close).toStringAsFixed(2);
    } else {
      if (today_open != 0) {
        gains_num = (current_prices - today_open).toStringAsFixed(2);
      } else {
        gains_num = "0.00";
      }
    }
  }
  return gains_num;
}

/**
 * 处理股票数据
 */
Stock DealStocks(String str) {
  Stock stock = new Stock();
  int start = str.indexOf("\"") + 1;
  int end = str.indexOf("\"", start);
  stock.stock_code2 = str.substring(str.indexOf("str_") + 4, start - 2);
  stock.stock_code = str.substring(str.indexOf("str_") + 6, start - 2);
  String stock_str = str.substring(start, end);
  List stock_item = stock_str.split(",");
  stock.name = stock_item[0];
  stock.today_open = double.parse(stock_item[1]);
  stock.yesterday_close = double.parse(stock_item[2]);
  stock.current_prices = double.parse(stock_item[3]);
  stock.today_highest_price = stock_item[4];
  stock.today_lowest_price = stock_item[5];
  stock.buy1_j = stock_item[6];
  stock.sell1_j = stock_item[7];
  stock.traded_num = double.parse(stock_item[8]);
  stock.traded_amount = double.parse(stock_item[9]);
  stock.buy1_apply_num = stock_item[10];
  stock.buy1 = stock_item[11];
  stock.buy2_apply_num = stock_item[12];
  stock.buy2 = stock_item[13];
  stock.buy3_apply_num = stock_item[14];
  stock.buy3 = stock_item[15];
  stock.buy4_apply_num = stock_item[16];
  stock.buy4 = stock_item[17];
  stock.buy5_apply_num = stock_item[18];
  stock.buy5 = stock_item[19];
  stock.sell1_apply_num = stock_item[20];
  stock.sell1 = stock_item[21];
  stock.sell2_apply_num = stock_item[22];
  stock.sell2 = stock_item[23];
  stock.sell3_apply_num = stock_item[24];
  stock.sell3 = stock_item[25];
  stock.sell4_apply_num = stock_item[26];
  stock.sell4 = stock_item[27];
  stock.sell5_apply_num = stock_item[28];
  stock.sell5 = stock_item[29];
  stock.date = stock_item[30];
  stock.time = stock_item[31];

  print("=========");
  print(stock);
  return stock;
}

/**
 * 处理指数数据
 */
void DealStockIndess(String str, StockIndex stockIndex) {
  int start = str.indexOf("\"") + 1;
  int end = str.indexOf("\"", start);
  stockIndex.stock_code2 = str.substring(str.indexOf("_s_") + 3, start - 2);
  stockIndex.stock_code = str.substring(str.indexOf("_s_") + 5, start - 2);
  String stock_index_str = str.substring(start, end);
  List index_item = stock_index_str.split(",");
  stockIndex.name = index_item[0];
  stockIndex.current_points = index_item[1];
  stockIndex.current_prices = index_item[2];
  stockIndex.gains_rate = index_item[3];
  stockIndex.traded_num = index_item[4];
  stockIndex.traded_amount = index_item[5];
}
