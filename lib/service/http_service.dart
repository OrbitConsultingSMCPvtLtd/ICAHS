import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String authority = "brevo.orbit-erps.com";
const String path = "/apex/a151218h/ichas/app";

class HttpService {
  final _client = http.Client();

  Future<http.Response> postRequest(
    String rPath,
    Map<String, dynamic>? params, [
    Map<String, dynamic>? body,
  ]) async {
    var url = Uri.https(authority, "$path$rPath", params);

    try {
      var res = await _client.post(url, body: body);

      if (res.statusCode != 200) {
        throw Exception("Something went wrong");
      }
      return res;
    } on HttpException catch (_) {
      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      throw Exception("Please check yout internet connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> postRequestEncoded(
    String rPath,
    [Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  ]) async {
    var url = Uri.https(authority, "$path$rPath", params);

    try {
      var res = await _client.post(url, body: jsonEncode(body));

      if (res.statusCode != 200) {
        throw Exception("Something went wrong");
      }
      return res;
    } on HttpException catch (_) {
      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      throw Exception("Please check yout internet connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> putRequestEncoded(
    String rPath, [
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  ]) async {
    var url = Uri.https(authority, "$path$rPath", params);

    try {
      var res = await _client.put(url, body: jsonEncode(body));

      if (res.statusCode != 200) {
        throw Exception("Something went wrong");
      }
      return res;
    } on HttpException catch (_) {
      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      throw Exception("Please check yout internet connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> getRequest(
    String rPath, [
    Map<String, dynamic>? params,
  ]) async {
    var url = Uri.https(authority, "$path$rPath", params);

    try {
      var res = await _client.get(url);

      if (res.statusCode != 200) {
        throw Exception("Something went wrong");
      }
      return res;
    } on HttpException catch (_) {
      throw Exception("HTTP Exception: Something went wrong");
    } on SocketException catch (_) {
      throw Exception("Please check your internet connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
