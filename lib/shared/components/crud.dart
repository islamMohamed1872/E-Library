// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

String _basicAuth = 'Basic ' +
    base64Encode(
        utf8.encode('islam.mohamed1872@gmail.com:islam mohamed__1872001'));

Map<String, String> myheaders = {'authorization': _basicAuth};

class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }

  postRequest(String url, Map data) async {
    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: myheaders);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }

  postRequestWithFile(
    String url,
    Map data,
    File image,
    File content,
  ) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var length = await image.length();
    var stream = http.ByteStream(image.openRead());
    var multiImageFile = http.MultipartFile(
      "file",
      stream,
      length,
      filename: basename(image.path),
    );
    var contentLength = await content.length();
    var contentStream = http.ByteStream(content.openRead());
    var multiContentFile = http.MultipartFile(
      "content",
      contentStream,
      contentLength,
      filename: basename(content.path),
    );
    request.headers.addAll(myheaders);

    request.files.add(multiImageFile);
    request.files.add(multiContentFile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });

    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error file upload : ${myRequest.statusCode}");
    }
  }

  postRequestWithImage(
    String url,
    Map data,
    File image,
  ) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var length = await image.length();
    var stream = http.ByteStream(image.openRead());
    var multiImageFile = http.MultipartFile(
      "file",
      stream,
      length,
      filename: basename(image.path),
    );
    request.headers.addAll(myheaders);

    request.files.add(multiImageFile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });

    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error file upload : ${myRequest.statusCode}");
    }
  }

  postRequestWithContent(
    String url,
    Map data,
    File content,
  ) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var contentLength = await content.length();
    var contentStream = http.ByteStream(content.openRead());
    var multiContentFile = http.MultipartFile(
      "content",
      contentStream,
      contentLength,
      filename: basename(content.path),
    );
    request.headers.addAll(myheaders);
    request.files.add(multiContentFile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });

    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error file upload : ${myRequest.statusCode}");
    }
  }
}
