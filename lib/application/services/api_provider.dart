import 'dart:convert';

import 'package:portfolio/application/theme/config.dart';
import 'package:http/http.dart' as http;

const BLOG_API =
    'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@mercyjemosop';

class ApiProvider {
  Future getBlogs() async {
    final response = await http.get(Uri.parse(Constants.BLOG_API));
    if (response.statusCode == 200) {
      var data = response.body;
      return jsonDecode(data);
    } else {
      return response.statusCode;
    }
  }
}
